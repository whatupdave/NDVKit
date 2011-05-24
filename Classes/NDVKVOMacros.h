/*
 * NDVKVOMacros.h
 *
 * Created by Nathan de Vries on 25/08/10.
 *
 * Copyright (c) 2008-2011, Nathan de Vries.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holder nor the names of any
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */



static NSString* NDVPropertyChangeObserverContext = @"com.atnan.PropertyChangeObserver";

#define OBSERVE_CHANGES_FOR_PROPERTIES(...) \
\
for (NSString* property in [NSArray arrayWithObjects:__VA_ARGS__, nil]) { \
  [self addObserver:self \
         forKeyPath:property \
            options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) \
            context:&NDVPropertyChangeObserverContext]; \
}


#define SYNTHESIZE_PROPERTY_CHANGE_OBSERVER() \
\
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context { \
  if (context != &NDVPropertyChangeObserverContext) return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context]; \
\
  if ([[change valueForKey:NSKeyValueChangeKindKey] integerValue] == NSKeyValueChangeSetting) { \
    SEL changeSelector = NSSelectorFromString([keyPath stringByAppendingString:@"DidChange"]); \
    SEL changeSelectorWithValues = NSSelectorFromString([keyPath stringByAppendingString:@"DidChangeWithOldValue:newValue:"]); \
\
    if ([self respondsToSelector:changeSelector]) { \
      [self performSelector:changeSelector]; \
\
    } else if ([self respondsToSelector:changeSelectorWithValues]) { \
      id oldValue = [change valueForKey:NSKeyValueChangeOldKey] ?: nil; \
      id newValue = [change valueForKey:NSKeyValueChangeNewKey]; \
\
      oldValue = (oldValue == [NSNull null]) ? nil : oldValue; \
\
      [self performSelector:changeSelectorWithValues withObject:oldValue withObject:newValue]; \
    } \
  } \
}
