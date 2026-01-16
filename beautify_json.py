import json
import os
import argparse
from typing import Optional


def beautify_json_file(path: str, indent: int = 4, sort_keys: bool = False) -> Optional[str]:
    """
    Load, pretty-print, and overwrite a JSON file.
    Returns an error message if the file is invalid JSON, otherwise None.
    """
    try:
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)

        with open(path, "w", encoding="utf-8") as f:
            json.dump(
                data,
                f,
                indent=indent,
                sort_keys=sort_keys,
                ensure_ascii=False
            )
            f.write("\n")

        return None
    except json.JSONDecodeError as e:
        return f"Invalid JSON ({e})"
    except OSError as e:
        return f"I/O error ({e})"


def beautify_json_in_directory(root: str, indent: int = 4) -> None:
    """
    Recursively beautify all .json files under the given directory.
    """
    for dirpath, _, filenames in os.walk(root):
        for filename in filenames:
            if filename.lower().endswith(".json"):
                full_path = os.path.join(dirpath, filename)
                error = beautify_json_file(full_path, indent)
                if error:
                    print(f"[SKIPPED] {full_path}: {error}")
                else:
                    print(f"[OK] {full_path}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Recursively beautify JSON files in a directory."
    )
    parser.add_argument(
        "path",
        help="Root directory to process"
    )
    parser.add_argument(
        "--indent",
        type=int,
        default=4,
        help="Number of spaces for indentation (default: 4)"
    )
    parser.add_argument(
        "--sort_keys",
        type=bool,
        default=False,
        help="Sort keys (default: False)"
    )

    args = parser.parse_args()

    if not os.path.isdir(args.path):
        raise ValueError(f"Not a directory: {args.path}")

    beautify_json_in_directory(args.path, args.indent, args.sort_keys)


if __name__ == "__main__":
    main()
