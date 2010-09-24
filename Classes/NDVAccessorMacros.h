//
//  NDVAccessorMacros.h
//  NDVKit
//
//  Created by Nathan de Vries on 24/09/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//


id objc_getProperty(id self, SEL _cmd, ptrdiff_t offset, BOOL atomic);
void objc_setProperty(id self, SEL _cmd, ptrdiff_t offset, id newValue, BOOL atomic, BOOL shouldCopy);
void objc_copyStruct(void *dest, const void *src, ptrdiff_t size, BOOL atomic, BOOL hasStrong);


#define AtomicRetainedSetToFrom(dest, source) \
  objc_setProperty(self, _cmd, (ptrdiff_t)(&dest) - (ptrdiff_t)(self), source, YES, NO)

#define AtomicCopiedSetToFrom(dest, source) \
  objc_setProperty(self, _cmd, (ptrdiff_t)(&dest) - (ptrdiff_t)(self), source, YES, YES)

#define AtomicAutoreleasedGet(source) \
  objc_getProperty(self, _cmd, (ptrdiff_t)(&source) - (ptrdiff_t)(self), YES)

#define AtomicStructToFrom(dest, source) \
  objc_copyStruct(&dest, &source, sizeof(__typeof__(source)), YES, NO)
