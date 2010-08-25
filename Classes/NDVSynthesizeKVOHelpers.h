//
//  NDVSynthesizeKVOHelpers.h
//  NDVKit
//
//  Created by Nathan de Vries on 25/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//


#define OBSERVE_CHANGES_FOR_PROPERTIES(...) \
\
for (NSString* property in [NSArray arrayWithObjects:__VA_ARGS__, nil]) { \
  [self addObserver:self \
         forKeyPath:property \
            options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) \
            context:NULL]; \
}


#define SYNTHESIZE_PROPERTY_CHANGE_OBSERVER() \
\
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context { \
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
