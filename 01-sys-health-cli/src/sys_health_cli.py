import argparse
import logging
from src.health import cpu_percent, mem_percent, disk_percent

logging.basicConfig(
    filename="sys_health.log",
    level=logging.ERROR,
    format="%(asctime)s - %(levelname)s - %(message)s",
)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="sys-health", description="system Health CLI Tool"
    )
    parser.add_argument("--cpu", action="store_true", help="show cpu usage")
    parser.add_argument("--mem", action="store_true", help="Show memory usage")
    parser.add_argument("--disk", action="store_true", help="Show Disk usage")
    parser.add_argument("--all", action="store_true", help="Show all metrics")
    return parser


def run(args: argparse.Namespace) -> None:
    try:
        if not (args.cpu or args.mem or args.disk or args.all):
            print("Please provide at least one flag: --cpu --mem --disk --all")
            return
        if args.all or args.cpu:
            print(f"CPU: {cpu_percent():.0f}%")
        if args.all or args.mem:
            print(f"MEM: {mem_percent():.0f}%")
        if args.all or args.disk:
            print(f"DISK: {disk_percent():.0f}%")
    except Exception as exc:
        logging.error("CLI falied", exc_info=True)
        print(f"Error: {exc}. Check sys_health.log for details")


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()
    run(args)


if __name__ == "__main__":
    main()
