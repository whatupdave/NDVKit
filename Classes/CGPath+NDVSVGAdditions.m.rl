/*
 * CGPath+NDVSVGAdditions.m
 *
 * Created by Nathan de Vries on 25/10/10.
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


#import "CGPath+NDVSVGAdditions.h"
#import "NDVCGPathBuilder.h"


%%{

  machine path;


  #######################################################
  ## Define the actions
  #######################################################

  action start_number {
    start = p;
  }

  action push_number {
    char *endmark = (char*)p;
    const char c = *endmark;
    *endmark = '\0';
    argv[argc++] = strtod(start, NULL);
    *endmark = c;
    start = NULL;
  }

  action push_true {
    [NSException raise:@"Ragel action push_true is not implemented" format:@""];
  }

  action push_false {
    [NSException raise:@"Ragel action push_false is not implemented" format:@""];
  }

  action mode_abs {
    absolute = YES;
  }

  action mode_rel {
    absolute = NO;
  }

  action moveto {
    [pathBuilder moveToPointWithX:argv[0] y:argv[1] absolute:absolute];
    argc = 0;
  }

  action lineto {
    [pathBuilder addLineToPointWithX:argv[0] y:argv[1] absolute:absolute];
    argc = 0;
  }

  action horizontal_lineto {
    [pathBuilder addHorizontalLineToPointWithX:argv[0] absolute:absolute];
    argc = 0;
  }

  action vertical_lineto {
    [pathBuilder addVerticalLineToPointWithY:argv[0] absolute:absolute];
    argc = 0;
  }

  action curveto {
    [pathBuilder addCubicCurveToPointWithCp1x:argv[0] cp1y:argv[1] cp2x:argv[2] cp2y:argv[3] x:argv[4] y:argv[5] absolute:absolute];
    argc = 0;
  }

  action smooth_curveto {
    [pathBuilder addSmoothCubicCurveToPointWithCp2x:argv[0] cp2y:argv[1] x:argv[2] y:argv[3] absolute:absolute];
    argc = 0;
  }

  action quadratic_bezier_curveto {
    [pathBuilder addQuadraticCurveToPointWithCpx:argv[0] cpy:argv[1] x:argv[2] y:argv[3] absolute:absolute];
    argc = 0;
  }

  action smooth_quadratic_bezier_curveto {
    [pathBuilder addSmoothQuadraticCurveToPointWithX:argv[0] y:argv[1] absolute:absolute];
    argc = 0;
  }

  action elliptical_arc {
    [NSException raise:@"Ragel action elliptical_arc is not implemented" format:@""];
    argc = 0;
  }

  action closepath {
    [pathBuilder closePath];
  }


  #######################################################
  ## Define the grammar
  #######################################################

  wsp = (' ' | 9 | 10 | 13);
  sign = ('+' | '-');
  digit_sequence = digit+;
  exponent = ('e' | 'E') sign? digit_sequence;
  fractional_constant =
      digit_sequence? '.' digit_sequence
      | digit_sequence '.';
  floating_point_constant =
      fractional_constant exponent?
      | digit_sequence exponent;
  integer_constant = digit_sequence;
  comma = ',';
  comma_wsp = (wsp+ comma? wsp*) | (comma wsp*);

  flag = ('0' %push_false | '1' %push_true);

  number =
      ( sign? integer_constant
       | sign? floating_point_constant )
      >start_number %push_number;

  nonnegative_number =
      ( integer_constant
       | floating_point_constant)
      >start_number %push_number;

  coordinate = number $(number,1) %(number,0);
  coordinate_pair = (coordinate $(coordinate_pair_a,1) %(coordinate_pair_a,0) comma_wsp? coordinate $(coordinate_pair_b,1) %(coordinate_pair_b,0)) $(coordinate_pair,1) %(coordinate_pair,0);
  elliptical_arc_argument =
      (nonnegative_number $(elliptical_arg_a,1) %(elliptical_arg_a,0) comma_wsp?
       nonnegative_number $(elliptical_arg_b,1) %(elliptical_arg_b,0) comma_wsp?
       number comma_wsp
       flag comma_wsp flag comma_wsp
       coordinate_pair)
      %elliptical_arc;
  elliptical_arc_argument_sequence =
      elliptical_arc_argument $1 %0
      (comma_wsp? elliptical_arc_argument $1 %0)*;
      elliptical_arc =
      ('A' %mode_abs| 'a' %mode_rel) wsp*
      elliptical_arc_argument_sequence;

  smooth_quadratic_bezier_curveto_argument =
      coordinate_pair %smooth_quadratic_bezier_curveto;
  smooth_quadratic_bezier_curveto_argument_sequence =
      smooth_quadratic_bezier_curveto_argument $1 %0
      (comma_wsp?
       smooth_quadratic_bezier_curveto_argument $1 %0)*;
  smooth_quadratic_bezier_curveto =
      ('T' %mode_abs| 't' %mode_rel) wsp*
      smooth_quadratic_bezier_curveto_argument_sequence;

  quadratic_bezier_curveto_argument =
      (coordinate_pair $1 %0 comma_wsp? coordinate_pair)
      %quadratic_bezier_curveto;
  quadratic_bezier_curveto_argument_sequence =
      quadratic_bezier_curveto_argument $1 %0
      (comma_wsp? quadratic_bezier_curveto_argument $1 %0)*;
  quadratic_bezier_curveto =
      ('Q' %mode_abs| 'q' %mode_rel) wsp*
      quadratic_bezier_curveto_argument_sequence;

  smooth_curveto_argument =
      (coordinate_pair $1 %0 comma_wsp? coordinate_pair)
      %smooth_curveto;
  smooth_curveto_argument_sequence =
      smooth_curveto_argument $1 %0
      (comma_wsp? smooth_curveto_argument $1 %0)*;
  smooth_curveto =
      ('S' %mode_abs| 's' %mode_rel)
      wsp* smooth_curveto_argument_sequence;

  curveto_argument =
      (coordinate_pair $1 %0 comma_wsp?
       coordinate_pair $1 %0 comma_wsp?
       coordinate_pair)
      %curveto;
  curveto_argument_sequence =
      curveto_argument $1 %0
      (comma_wsp? curveto_argument $1 %0)*;
  curveto =
      ('C' %mode_abs| 'c' %mode_rel)
      wsp* curveto_argument_sequence;

  vertical_lineto_argument = coordinate %vertical_lineto;
  vertical_lineto_argument_sequence =
      vertical_lineto_argument $(vertical_lineto_argument_a,1) %(vertical_lineto_argument_a,0)
      (comma_wsp? vertical_lineto_argument $(vertical_lineto_argument_b,1) %(vertical_lineto_argument_b,0))*;
  vertical_lineto =
      ('V' %mode_abs| 'v' %mode_rel)
      wsp* vertical_lineto_argument_sequence;

  horizontal_lineto_argument = coordinate %horizontal_lineto;
  horizontal_lineto_argument_sequence =
      horizontal_lineto_argument $(horizontal_lineto_argument_a,1) %(horizontal_lineto_argument_a,0)
      (comma_wsp? horizontal_lineto_argument $(horizontal_lineto_argument_b,1) %(horizontal_lineto_argument_b,0))*;
  horizontal_lineto =
      ('H' %mode_abs| 'h' %mode_rel)
      wsp* horizontal_lineto_argument_sequence;

  lineto_argument = coordinate_pair %lineto;
  lineto_argument_sequence =
      lineto_argument $1 %0
      (comma_wsp? lineto_argument $1 %0)*;
  lineto =
      ('L' %mode_abs| 'l' %mode_rel) wsp*
      lineto_argument_sequence;

  closepath = ('Z' | 'z') %closepath;

  moveto_argument = coordinate_pair %moveto;
  moveto_argument_sequence =
      moveto_argument $1 %0
      (comma_wsp? lineto_argument $1 %0)*;
  moveto =
      ('M' %mode_abs | 'm' %mode_rel)
      wsp* moveto_argument_sequence;

  drawto_command =
      closepath | lineto |
      horizontal_lineto | vertical_lineto |
      curveto | smooth_curveto |
      quadratic_bezier_curveto |
      smooth_quadratic_bezier_curveto |
      elliptical_arc;

  drawto_commands = drawto_command (wsp* drawto_command)*;
  moveto_drawto_command_group = moveto wsp* drawto_commands?;
  moveto_drawto_command_groups =
      moveto_drawto_command_group
      (wsp* moveto_drawto_command_group)*;

  svg_path = wsp* moveto_drawto_command_groups? wsp*;

  main := svg_path;

  write data;

}%%


CGPathRef CGPathCreateByParsingSVGPathString(NSString* pathString) {
  NDVCGPathBuilder* pathBuilder = [NDVCGPathBuilder pathBuilderWithTransform:NULL];

  const char* data = [pathString UTF8String];

  if (data == NULL)
    return CGPathRetain([pathBuilder path]);


  const int length = strlen(data);


  // high-level buffers
  const char *start = NULL;
  CGFloat argv[] = {0,1,2,3,4,5,6,7};
  int argc = 0;
  BOOL absolute = YES;

  // ragel variables (low level)
  const char *p = data;
  const char *pe = data + length; // pointer "end"
  const char *eof = pe;
  int cs = 0;


  %% write init;
  %% write exec;


  if (cs < path_first_final)
    return NULL;


  return CGPathRetain([pathBuilder path]);
}
