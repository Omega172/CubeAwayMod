#pragma once
#include <stddef.h>
#include <stdint.h>

struct alignas(16) stGameplayContext
{
    uint64_t aRegisters[31];
    uint64_t uFlags;
    uint8_t aVectorRegisters[512];
    uint64_t uNextAddress;
    uint64_t uHookId;
};

static_assert(offsetof(stGameplayContext, uFlags) == 248);
static_assert(offsetof(stGameplayContext, aVectorRegisters) == 256);
static_assert(offsetof(stGameplayContext, uNextAddress) == 768);
static_assert(offsetof(stGameplayContext, uHookId) == 776);
static_assert(sizeof(stGameplayContext) == 784);

extern "C" __attribute__((visibility("default"))) void OmegaGameplayHook(stGameplayContext *pstContext, uint32_t uHookId, uintptr_t uImageBase);
