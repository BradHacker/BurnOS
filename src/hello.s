.code16
.global init

init:
  mov $0x0, %ah
  mov $0x03, %al
  int $0x10
  mov $msg, %si
  mov $0x0e, %ah # mov teletype (0e) into ah
  print_char:
    lodsb
    cmp $0, %al
    je done
    int $0x10
    jmp print_char
  done:
    hlt

msg: .asciz "  _    _      _ _        __          __        _     _ \r\n | |  | |    | | |       \\ \\        / /       | |   | |\r\n | |__| | ___| | | ___    \\ \\  /\\  / /__  _ __| | __| |\r\n |  __  |/ _ \\ | |/ _ \\    \\ \\/  \\/ / _ \\| '__| |/ _` |\r\n | |  | |  __/ | | (_) |    \\  /\\  / (_) | |  | | (_| |\r\n |_|  |_|\\___|_|_|\\___/      \\/  \\/ \\___/|_|  |_|\\__,_|\r\n"

.fill (510-(.-init)), 1, 0
.word 0xaa55
