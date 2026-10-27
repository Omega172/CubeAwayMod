#include "Gameplay.h"
#include <assert.h>
#include <stdio.h>

static int32_t GetMaxHearts(void *pInstance, const void *pMethod)
{
    assert(pInstance == reinterpret_cast<void *>(1234));
    assert(pMethod == nullptr);
    return 7;
}

int main()
{
    stGameplayContext stContext{};
    stContext.aRegisters[8] = 100;
    stContext.aRegisters[20] = 25;
    OmegaGameplayHook(&stContext, 0, 0x100000000);
    assert(stContext.aRegisters[8] == 125);
    assert(stContext.uNextAddress == 0x10304842C);
    stContext.aRegisters[8] = 0xFFFFFFFF;
    stContext.aRegisters[20] = 1;
    OmegaGameplayHook(&stContext, 0, 0);
    assert(stContext.aRegisters[8] == 0);
    for (uint32_t uHook = 1; uHook <= 2; ++uHook)
    {
        stContext.aRegisters[0] = 1234;
        stContext.aRegisters[30] = 0xABCDEF;
        OmegaGameplayHook(&stContext, uHook, 0);
        assert(stContext.aRegisters[0] == 1);
        assert(stContext.uNextAddress == 0xABCDEF);
    }
    stContext.aRegisters[0] = 1234;
    OmegaGameplayHook(&stContext, 3, reinterpret_cast<uintptr_t>(&GetMaxHearts) - 0x317DBE0);
    assert(stContext.aRegisters[0] == 7);
    assert(stContext.uNextAddress == 0xABCDEF);
    stContext.aRegisters[8] = 3;
    stContext.uFlags = 0xA0000000;
    OmegaGameplayHook(&stContext, 4, 0);
    assert(stContext.aRegisters[1] == 3);
    assert(stContext.uFlags == 0xA0000000);
    uint32_t aValues[] = { 0, 1, 3, 0x80000000 };
    for (uint32_t uValue : aValues)
    {
        stContext.aRegisters[8] = uValue;
        OmegaGameplayHook(&stContext, 5, 0);
        assert(stContext.aRegisters[1] == uValue);
        assert(stContext.uFlags == ((uValue & 0x80000000U) | (uValue == 0 ? 0x40000000U : 0U) | 0x20000000U));
    }
    stContext.aRegisters[8] = 3;
    OmegaGameplayHook(&stContext, 6, 0);
    assert(stContext.aRegisters[8] == 3);
    stContext.uNextAddress = 123;
    OmegaGameplayHook(&stContext, 99, 0);
    assert(stContext.uNextAddress == 123);
    OmegaGameplayHook(nullptr, 0, 0);
    puts("C++ gameplay handler checks passed");
}
