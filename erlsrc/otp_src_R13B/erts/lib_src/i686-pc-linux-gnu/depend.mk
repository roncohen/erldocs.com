# Generated dependency rules
# 
# ethread lib objects...
$(r_OBJ_DIR)/ethread.o: common/ethread.c \
  /home/dale/apps/otp_src_R13B/erts/$(TARGET)/config.h \
  ../include/internal/ethread.h ../include/internal/erl_errno.h \
  ../include/internal/i386/ethread.h ../include/internal/i386/atomic.h \
  ../include/internal/i386/spinlock.h ../include/internal/i386/rwlock.h
# erts_internal_r lib objects...
$(r_OBJ_DIR)/erl_printf_format.o: common/erl_printf_format.c \
  /home/dale/apps/otp_src_R13B/erts/$(TARGET)/config.h \
  ../include/internal/erl_errno.h ../include/internal/erl_printf.h \
  ../include/internal/erl_printf_format.h
$(r_OBJ_DIR)/erl_printf.o: common/erl_printf.c \
  /home/dale/apps/otp_src_R13B/erts/$(TARGET)/config.h \
  ../include/internal/erl_errno.h ../include/internal/erl_printf.h \
  ../include/internal/erl_printf_format.h
$(r_OBJ_DIR)/erl_misc_utils.o: common/erl_misc_utils.c \
  /home/dale/apps/otp_src_R13B/erts/$(TARGET)/config.h \
  ../include/internal/erl_misc_utils.h ../include/internal/erl_errno.h
# erts_internal lib objects...
$(OBJ_DIR)/erl_printf_format.o: common/erl_printf_format.c \
  /home/dale/apps/otp_src_R13B/erts/$(TARGET)/config.h \
  ../include/internal/erl_errno.h ../include/internal/erl_printf.h \
  ../include/internal/erl_printf_format.h
$(OBJ_DIR)/erl_printf.o: common/erl_printf.c \
  /home/dale/apps/otp_src_R13B/erts/$(TARGET)/config.h \
  ../include/internal/erl_errno.h ../include/internal/erl_printf.h \
  ../include/internal/erl_printf_format.h
$(OBJ_DIR)/erl_misc_utils.o: common/erl_misc_utils.c \
  /home/dale/apps/otp_src_R13B/erts/$(TARGET)/config.h \
  ../include/internal/erl_misc_utils.h ../include/internal/erl_errno.h
# erts_r lib objects...
$(r_OBJ_DIR)/erl_memory_trace_parser.o: common/erl_memory_trace_parser.c \
  ../include/erl_memory_trace_parser.h \
  ../include/erl_fixed_size_int_types.h \
  ../include/$(TARGET)/erl_int_sizes_config.h \
  ../include/internal/erl_memory_trace_protocol.h
# erts lib objects...
$(OBJ_DIR)/erl_memory_trace_parser.o: common/erl_memory_trace_parser.c \
  ../include/erl_memory_trace_parser.h \
  ../include/erl_fixed_size_int_types.h \
  ../include/$(TARGET)/erl_int_sizes_config.h \
  ../include/internal/erl_memory_trace_protocol.h
# EOF
