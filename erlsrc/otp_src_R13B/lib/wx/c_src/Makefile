#
# %CopyrightBegin%
# 
# Copyright Ericsson AB 2008-2009. All Rights Reserved.
# 
# The contents of this file are subject to the Erlang Public License,
# Version 1.1, (the "License"); you may not use this file except in
# compliance with the License. You should have received a copy of the
# Erlang Public License along with this software. If not, it can be
# retrieved online at http://www.erlang.org/.
# 
# Software distributed under the License is distributed on an "AS IS"
# basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
# the License for the specific language governing rights and limitations
# under the License.
# 
# %CopyrightEnd%
#

include ../vsn.mk
include ../config.mk

ifneq ($(TYPE),debug)
override TYPE=opt
endif

SO_EXT    = .so

GENERAL     = wxe_driver wxe_ps_init wxe_impl wxePrintout wxe_return
GENERAL_H   = wxe_driver.h wxe_impl.h wxe_return.h

GENERATED_F = wxe_funcs wxe_events wxe_init
GENERATED_H = gen/wxe_macros.h gen/glu_finit.h gen/gl_finit.h gen/gl_fdefs.h 

HAVE_OPENGL = true
OPENGL_F = gl_funcs wxe_gl

ifneq ($(INSIDE_ERLSRC),true)

ERL_DIR = /home/dale/apps/otp_src_R13B
ERL_INCS = -I$(ERL_DIR)/usr/include

else
ERLANG_OSTYPE = i686-pc-linux-gnu

ERL_INCS= -I$(ERL_TOP)/erts/emulator/beam \
	   -I$(ERL_TOP)/erts/emulator/sys/$(ERLANG_OSTYPE) \
	   -I$(ERL_TOP)/erts/include/internal \
	   -I$(ERL_TOP)/erts/include/internal/$(ERLANG_OSTYPE) \
	   -I$(ERL_TOP)/erts/include \
	   -I$(ERL_TOP)/erts/include/$(ERLANG_OSTYPE)

endif

SYS_TYPE    = i686-pc-linux-gnu

GENERAL_O   = $(GENERAL:%=$(SYS_TYPE)/%.o) 
GENERATED_O = $(GENERATED_F:%=$(SYS_TYPE)/%.o)
ifeq ($(HAVE_OPENGL), true)
	OPENGL_O = $(OPENGL_F:%=$(SYS_TYPE)/%.o)
else
	OPENGL_O = 
endif

RC_FILE_EXT = o
ifeq ($(SYS_TYPE),win32)
RC_FILE     = $(SYS_TYPE)/wxe_win32.$(RC_FILE_EXT)
else 
RC_FILE     = 
endif

OBJECTS     = $(GENERAL_O) $(GENERATED_O) $(OPENGL_O) $(RC_FILE)

TARGET_API = wxe_driver
TARGET_DIR = ../priv/$(SYS_TYPE)

# -O2 -funroll-loops  -ffast-math -fomit-frame-pointer 

COMMON_CFLAGS = -DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\" -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_GL_GL_H=1 -DHAVE_GL_SUPPORT=1 -DHAVE_GLINTPTR=1 -DHAVE_GLINTPTRARB=1 -DHAVE_GLCHAR=1 -DHAVE_GLCHARARB=1 -DHAVE_GLHALFARB=1 -DHAVE_GLINT64EXT=1 -DHAVE_WX_STC_STC_H=1  $(ERL_INCS) 

CC		= gcc
CPP		= g++
LD		= $(CPP)
LDFLAGS		= -shared -fPIC
RESCOMP		= 


ifeq (false,true) 
WX_LIBS	         =  
DEBUG_WX_LIBS    =  
else
WX_LIBS	         =  -pthread -Wl,-Bsymbolic-functions  -lwx_gtk2u_stc-2.8 -lwx_gtk2u_xrc-2.8 -lwx_gtk2u_html-2.8 -lwx_gtk2u_adv-2.8 -lwx_baseu_xml-2.8 -lwx_gtk2u_core-2.8 -lwx_baseu-2.8 -lwx_gtk2u_gl-2.8 -lwx_gtk2u_aui-2.8 
DEBUG_WX_LIBS    =  
endif

ifeq ($(TYPE),debug)
CFLAGS		=  -g -Wall -fPIC -DDEBUG   -D_GNU_SOURCE -D_THREAD_SAFE -D_REENTRANT 
CPP_FLAGS	=  -g -Wall -fPIC -DDEBUG   -D_GNU_SOURCE -D_THREAD_SAFE -D_REENTRANT
LIBS		= $(DEBUG_WX_LIBS)
else
CFLAGS		= -I/usr/lib/wx/include/gtk2-unicode-release-2.8 -I/usr/include/wx-2.8 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES -D__WXGTK__ -pthread -g -Wall -O2 -fPIC -fomit-frame-pointer -fno-strict-aliasing   -D_GNU_SOURCE -D_THREAD_SAFE -D_REENTRANT 
CPP_FLAGS	= -I/usr/lib/wx/include/gtk2-unicode-release-2.8 -I/usr/include/wx-2.8 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES -D__WXGTK__ -pthread -g -Wall -O2 -fPIC -fomit-frame-pointer -fno-strict-aliasing   -D_GNU_SOURCE -D_THREAD_SAFE -D_REENTRANT
LIBS		= $(WX_LIBS)
endif

CC_O		= $(CC) -c $(CFLAGS) $(COMMON_CFLAGS)
CPP_O		= $(CPP) -c $(CPP_FLAGS) $(COMMON_CFLAGS) 

# Targets

opt:     $(TARGET_DIR)/$(TARGET_API)$(SO_EXT) 

debug:   
	@${MAKE} TYPE=debug

clean:  
	rm -f $(OBJECTS) 
	rm -f ../priv/$(TARGET_DIR)/$(TARGET_API)$(SO_EXT)
	rm -f *~ erl_crash.dump

complete_clean: 
	rm -f $(OBJECTS) 
	rm -f $(GENERATED_F:%=gen/%.cpp)
	rm -f gen/gl_funcs.cpp 
	rm -f $(GENERATED_H)
	rm -f ../priv/*/*
	rm -f *~ erl_crash.dump
	rm -f Makefile

docs:	


$(SYS_TYPE)/%.o: %.cpp $(GENERATED_H) $(GENERAL_H) 
	mkdir -p $(SYS_TYPE)
	$(CPP_O) $< -o $@

$(SYS_TYPE)/%.o: %.c $(GENERATED_H) $(GENERAL_H)
	mkdir -p $(SYS_TYPE)
	$(CC_O) $< -o $@

$(SYS_TYPE)/%.o: gen/%.cpp $(GENERATED_H) $(GENERAL_H)
	mkdir -p $(SYS_TYPE)
	$(CPP_O) $< -o $@

$(SYS_TYPE)/%.o: gen/%.c $(GENERATED_H) $(GENERAL_H)
	mkdir -p $(SYS_TYPE)
	$(CC_O) $< -o $@

$(SYS_TYPE)/wxe_win32.$(RC_FILE_EXT): wxe_win32.rc
	mkdir -p $(SYS_TYPE)
	$(RESCOMP) -o $@ $< 

$(TARGET_DIR)/$(TARGET_API)$(SO_EXT): $(OBJECTS)
	mkdir -p $(TARGET_DIR)
	$(LD) $(LDFLAGS)  $(OBJECTS) $(LIBS) -o $@


# ----------------------------------------------------
# Release Target
# ----------------------------------------------------
ifeq ($(INSIDE_ERLSRC),true)
include $(ERL_TOP)/make/otp_release_targets.mk
release_spec: opt
	$(INSTALL_DIR) $(RELSYSDIR)/priv/$(SYS_TYPE)
	$(INSTALL_DATA) $(TARGET_DIR)/$(TARGET_API)$(SO_EXT) $(RELSYSDIR)/priv/$(SYS_TYPE)

release_docs_spec:

endif
