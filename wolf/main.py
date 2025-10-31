import sys

# Windows 高 DPI 清晰度提升（可忽略异常）
try:
    import ctypes
    try:
        ctypes.windll.shcore.SetProcessDpiAwareness(1)
    except Exception:
        ctypes.windll.user32.SetProcessDPIAware()
except Exception:
    pass


def main():
    import tkinter as tk
    from gui.main_window import WerewolfApp

    root = tk.Tk()
    app = WerewolfApp(root)
    # 如果 WerewolfApp 内未设置窗口大小/标题，可在此按需设置：
    # root.geometry('1000x720')
    root.mainloop()


if __name__ == '__main__':
    main()
