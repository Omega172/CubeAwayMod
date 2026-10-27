#include "Gameplay.h"

extern "C" void OmegaGameplayHook(stGameplayContext *pstContext, uint32_t uHookId, uintptr_t uImageBase)
{
    static constexpr uint32_t aSites[] = { 0x3048428, 0x317CB14, 0x317DD64, 0x317B048, 0x3061A18, 0x306B554, 0x306D054 };
    if (!pstContext || uHookId >= sizeof(aSites) / sizeof(aSites[0]))
        return;
    pstContext->uNextAddress = uImageBase + aSites[uHookId] + 4;
    switch (uHookId)
    {
        case 0:
            pstContext->aRegisters[8] = static_cast<uint32_t>(pstContext->aRegisters[8]) + static_cast<uint32_t>(pstContext->aRegisters[20]);
            break;
        case 1:
        case 2:
            pstContext->aRegisters[0] = 1;
            pstContext->uNextAddress = pstContext->aRegisters[30];
            break;
        case 3:
        {
            using pfnMaxHearts = int32_t (*)(void *, const void *);
            auto pGetMaxHearts = reinterpret_cast<pfnMaxHearts>(uImageBase + 0x317DBE0);
            pstContext->aRegisters[0] = static_cast<uint32_t>(pGetMaxHearts(reinterpret_cast<void *>(pstContext->aRegisters[0]), nullptr));
            pstContext->uNextAddress = pstContext->aRegisters[30];
            break;
        }
        case 4:
            pstContext->aRegisters[1] = static_cast<uint32_t>(pstContext->aRegisters[8]);
            break;
        case 5:
        {
            uint32_t uCount = static_cast<uint32_t>(pstContext->aRegisters[8]);
            pstContext->aRegisters[1] = uCount;
            pstContext->uFlags = (uCount & 0x80000000U) | (uCount == 0 ? 0x40000000U : 0U) | 0x20000000U;
            break;
        }
        case 6:
            break;
    }
}
