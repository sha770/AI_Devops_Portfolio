import psutil


def cpu_percent() -> float:
    return float(psutil.cpu_percent())


def mem_percent() -> float:
    return float(psutil.virtual_memory().percent)


def disk_percent() -> float:
    return float(psutil.disk_usage("/").percent)
