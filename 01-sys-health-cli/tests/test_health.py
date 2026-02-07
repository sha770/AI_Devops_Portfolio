from src.health import cpu_percent, mem_percent, disk_percent


def test_cpu_in_range() -> None:
    val = cpu_percent()
    assert 0.0 <= val <= 100.0


def test_mem_in_range() -> None:
    val = mem_percent()
    assert 0.0 <= val <= 100.0


def test_disk_in_range() -> None:
    val = disk_percent()
    assert 0.0 <= val <= 100.0
