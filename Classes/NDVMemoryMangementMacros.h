//
//  NDVMemoryMangementMacros.h
//  NDVKit
//
//  Created by Nathan de Vries on 26/08/10.
//  Copyright 2010 Nathan de Vries. All rights reserved.
//


# define RELEASE_AND_SET_TO_NIL(...) \
  for (id __POINTER in [NSArray arrayWithObjects:__VA_ARGS__, nil]) { \
    [__POINTER release]; __POINTER = nil; \
  }
