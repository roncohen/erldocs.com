/*
 * %CopyrightBegin%
 * 
 * Copyright Ericsson AB 1999-2009. All Rights Reserved.
 * 
 * The contents of this file are subject to the Erlang Public License,
 * Version 1.1, (the "License"); you may not use this file except in
 * compliance with the License. You should have received a copy of the
 * Erlang Public License along with this software. If not, it can be
 * retrieved online at http://www.erlang.org/.
 * 
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
 * the License for the specific language governing rights and limitations
 * under the License.
 * 
 * %CopyrightEnd%
 */

gzFile erts_gzopen (const char *path, const char *mode);
int erts_gzread(gzFile file, voidp buf, unsigned len);
int erts_gzwrite(gzFile file, voidp buf, unsigned len);
int erts_gzseek(gzFile, int, int);
int erts_gzflush(gzFile file, int flush);
int erts_gzclose(gzFile file);
ErlDrvBinary* erts_gzinflate_buffer(char*, uLong);
ErlDrvBinary* erts_gzdeflate_buffer(char*, uLong);
