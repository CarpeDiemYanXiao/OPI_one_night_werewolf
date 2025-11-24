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

    # 让窗口根据屏幕尺寸自适应：优先尝试 1000x720；若屏幕更小则使用全屏
    try:
        # 隐藏窗口以便测量屏幕尺寸
        root.withdraw()
        root.update_idletasks()
        sw = root.winfo_screenwidth()
        sh = root.winfo_screenheight()
        target_w = min(1000, sw)
        target_h = min(720, sh)
        if sw < 1000 or sh < 720:
            # 屏幕较小，使用全屏以确保界面元素可见
            try:
                root.attributes('-fullscreen', True)
            except Exception:
                try:
                    root.state('zoomed')
                except Exception:
                    root.geometry(f"{target_w}x{target_h}")
        else:
            # 常规尺寸，设置期望窗口大小并置中
            x = max(0, (sw - target_w) // 2)
            y = max(0, (sh - target_h) // 2)
            root.geometry(f"{target_w}x{target_h}+{x}+{y}")
        # 允许通过 Esc 退出全屏（方便调试）
        def _exit_fullscreen(event=None):
            try:
                root.attributes('-fullscreen', False)
            except Exception:
                try:
                    root.state('normal')
                except Exception:
                    pass
        root.bind('<Escape>', _exit_fullscreen)
    except Exception:
        # 测量或设置窗口失败时回退为默认大小
        try:
            root.geometry('1000x720')
        except Exception:
            pass

    # 创建并运行应用
    app = WerewolfApp(root)
    root.deiconify()
    root.mainloop()


if __name__ == '__main__':
    main()
