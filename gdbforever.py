#!/usr/bin/env python3
#
#       gdbforever.py 
#
# Copyright (c) 2014, Thibault Saunier tsaunier@gnome.org
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program; if not, write to the
# Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
# Boston, MA 02110-1301, USA.

import os
import sys
import time
import select

import argparse

def pprint(message):
    print("\n--> %s\n" %(message))

if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("-d", "--debug", dest="debug",
                      action="store_true",
                      default=False)
    parser.add_argument("-b", "--breakpoints", dest="breakpoints",
                      default=[])
    starting_time = time.time()
    n = 0
    (options, args) = parser.parse_known_args()
    while True:
        l = ' '.join(args)
        pprint("Launching: %s" % l)
        gdblaunch = "CK_FORK=no G_DEBUG=fatal_warnings gdb -ex 'set breakpoint pending on' -ex 'break send_failure_info' -ex 'set pagination off'"
        if options.debug:
            print(breakpoints)
            for b in options.breakpoints:
                gdblaunch += " -ex break %s" % b
            l = gdblaunch + "  -ex y -ex run -ex 't a a bt' -ex quit --args %s" % l
            res = os.system(l)
        else:
            res = os.system(l)

        if res != 0:
            print("==============>>>>>> Failed")
            exit(1)
        print("Res %i" %res)

        n += 1
        pprint ("Ran %d times for a total of %d seconds" % (n, int(time.time() - starting_time)))
        print ("\n=> Press any key to quite with the next sec\n")
        i, o, e = select.select([sys.stdin], [], [], 1)
        if i:
            print ("Quitting")
            exit(0)
