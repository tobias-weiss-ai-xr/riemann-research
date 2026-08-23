#!/usr/bin/env python3
"""Worker script for taskfleet that calls a local vllm endpoint directly."""
import argparse
import json
import os
import sys
import urllib.request
import urllib.error
import time

VLLM_BASE_URL = os.environ.get("VLLM_BASE_URL", "http://192.168.42.42:10801/v1")
DEFAULT_MODEL = os.environ.get("VLLM_MODEL", "deepseek-v4-flash")
DEFAULT_MAX_TOKENS = int(os.environ.get("VLLM_MAX_TOKENS", "16384"))


def call_vllm(prompt: str, output_file: str, model: str = DEFAULT_MODEL,
              max_tokens: int = DEFAULT_MAX_TOKENS) -> str:
    """Send prompt to vllm (non-streaming), extract content from response."""
    url = f"{VLLM_BASE_URL}/chat/completions"
    headers = {"Content-Type": "application/json"}
    payload = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
        "max_tokens": max_tokens,
        "stream": False,
        "temperature": 0.4,
        "reasoning_effort": "low",
    }

    os.makedirs(os.path.dirname(output_file) or ".", exist_ok=True)

    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers=headers,
        method="POST",
    )

    start = time.time()
    print(f"Sending {len(prompt)} chars prompt to {model} (max_tokens={max_tokens})...", flush=True)
    try:
        with urllib.request.urlopen(req, timeout=7200) as resp:
            raw = resp.read()
            elapsed = time.time() - start
            data = json.loads(raw)
    except urllib.error.URLError as e:
        print(f"Error connecting to vllm: {e.reason}", file=sys.stderr, flush=True)
        sys.exit(1)
    except Exception as e:
        print(f"Error during generation: {e}", file=sys.stderr, flush=True)
        sys.exit(1)

    choice = data.get("choices", [{}])[0]
    msg = choice.get("message", {})
    content = msg.get("content") or ""
    reasoning = msg.get("reasoning") or ""
    finish = choice.get("finish_reason", "")
    usage = data.get("usage", {})

    elapsed_min = elapsed / 60
    print(f"Done in {elapsed_min:.1f}min: finish={finish}, "
          f"usage={usage.get('prompt_tokens',0)}+{usage.get('completion_tokens',0)} tokens, "
          f"{len(reasoning)} chars reasoning, {len(content)} chars content",
          flush=True)

    if not content.strip():
        print(f"Warning: vllm returned empty content. finish_reason={finish}", file=sys.stderr, flush=True)
        if reasoning.strip():
            content = f"# Note: model returned only reasoning tokens\n\n{reasoning}"

    # Strip leading blank lines (model sometimes starts with \n before ---)
    content = content.lstrip("\n")

    with open(output_file, "w") as f:
        f.write(content)

    lines = content.count("\n") + 1
    print(f"Written {len(content)} chars ({lines} lines) to {output_file}", flush=True)
    return content


def main():
    parser = argparse.ArgumentParser(description="vllm worker for taskfleet")
    parser.add_argument("--prompt", required=True, help="Path to prompt file")
    parser.add_argument("--output", required=True, help="Path to output file")
    parser.add_argument("--model", default=DEFAULT_MODEL, help="Model name")
    parser.add_argument("--max-tokens", type=int, default=DEFAULT_MAX_TOKENS, help="Max tokens")
    args = parser.parse_args()

    with open(args.prompt) as f:
        prompt = f.read()

    call_vllm(prompt, args.output, model=args.model, max_tokens=args.max_tokens)


if __name__ == "__main__":
    main()
