/*
 *  Warning: Do not edit this file.  It was automatically
 *  generated by 'beam_makeops' on Fri Jul 31 14:49:33 2009.
 */

OpCase(allocate_heap_III):
    { 
    Eterm* next;
    PreFetch(3, next);
    AllocateHeap(Arg(0), Arg(1), Arg(2));
    NextPF(3, next);
    }

OpCase(allocate_heap_zero_III):
    { 
    Eterm* next;
    PreFetch(3, next);
    AllocateHeapZero(Arg(0), Arg(1), Arg(2));
    NextPF(3, next);
    }

OpCase(allocate_init_tIy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(0);
    AllocateInit(tb(tmp_packed1&BEAM_LOOSE_MASK), Arg(1), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(2, next);
    }

OpCase(allocate_tt):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    Allocate(tb(tmp_packed1&BEAM_LOOSE_MASK), tb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(allocate_zero_tt):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    AllocateZero(tb(tmp_packed1&BEAM_LOOSE_MASK), tb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(deallocate_return_P):
    DeallocateReturn(Arg(0));

OpCase(extract_next_element2_x):
    { 
    Eterm* next;
    PreFetch(1, next);
    ExtractNextElement2(xb(Arg(0)));
    NextPF(1, next);
    }

OpCase(extract_next_element2_y):
    { 
    Eterm* next;
    PreFetch(1, next);
    ExtractNextElement2(yb(Arg(0)));
    NextPF(1, next);
    }

OpCase(extract_next_element3_x):
    { 
    Eterm* next;
    PreFetch(1, next);
    ExtractNextElement3(xb(Arg(0)));
    NextPF(1, next);
    }

OpCase(extract_next_element3_y):
    { 
    Eterm* next;
    PreFetch(1, next);
    ExtractNextElement3(yb(Arg(0)));
    NextPF(1, next);
    }

OpCase(extract_next_element_x):
    { 
    Eterm* next;
    PreFetch(1, next);
    ExtractNextElement(xb(Arg(0)));
    NextPF(1, next);
    }

OpCase(extract_next_element_y):
    { 
    Eterm* next;
    PreFetch(1, next);
    ExtractNextElement(yb(Arg(0)));
    NextPF(1, next);
    }

OpCase(get_list_rrx):
    { 
    Eterm* next;
    PreFetch(1, next);
    GetList(r(0), r(0), xb(Arg(0)));
    NextPF(1, next);
    }

OpCase(get_list_rry):
    { 
    Eterm* next;
    PreFetch(1, next);
    GetList(r(0), r(0), yb(Arg(0)));
    NextPF(1, next);
    }

OpCase(get_list_rxr):
    { 
    Eterm* next;
    PreFetch(1, next);
    GetList(r(0), xb(Arg(0)), r(0));
    NextPF(1, next);
    }

OpCase(get_list_rxx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(r(0), xb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(get_list_rxy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(r(0), xb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(get_list_ryr):
    { 
    Eterm* next;
    PreFetch(1, next);
    GetList(r(0), yb(Arg(0)), r(0));
    NextPF(1, next);
    }

OpCase(get_list_ryx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(r(0), yb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(get_list_ryy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(r(0), yb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(get_list_xrx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(xb(tmp_packed1&BEAM_LOOSE_MASK), r(0), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(get_list_xry):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(xb(tmp_packed1&BEAM_LOOSE_MASK), r(0), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(get_list_xxr):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(xb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), r(0));
    NextPF(1, next);
    }

OpCase(get_list_xxx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(xb(tmp_packed1&BEAM_TIGHT_MASK), xb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), xb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK));
    NextPF(1, next);
    }

OpCase(get_list_xxy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(xb(tmp_packed1&BEAM_TIGHT_MASK), xb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), yb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK));
    NextPF(1, next);
    }

OpCase(get_list_xyr):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(xb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)), r(0));
    NextPF(1, next);
    }

OpCase(get_list_xyx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(xb(tmp_packed1&BEAM_TIGHT_MASK), yb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), xb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK));
    NextPF(1, next);
    }

OpCase(get_list_xyy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(xb(tmp_packed1&BEAM_TIGHT_MASK), yb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), yb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK));
    NextPF(1, next);
    }

OpCase(get_list_yrx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(yb(tmp_packed1&BEAM_LOOSE_MASK), r(0), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(get_list_yry):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(yb(tmp_packed1&BEAM_LOOSE_MASK), r(0), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(get_list_yxr):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(yb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), r(0));
    NextPF(1, next);
    }

OpCase(get_list_yxx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(yb(tmp_packed1&BEAM_TIGHT_MASK), xb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), xb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK));
    NextPF(1, next);
    }

OpCase(get_list_yxy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(yb(tmp_packed1&BEAM_TIGHT_MASK), xb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), yb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK));
    NextPF(1, next);
    }

OpCase(get_list_yyr):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(yb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)), r(0));
    NextPF(1, next);
    }

OpCase(get_list_yyx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(yb(tmp_packed1&BEAM_TIGHT_MASK), yb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), xb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK));
    NextPF(1, next);
    }

OpCase(get_list_yyy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    GetList(yb(tmp_packed1&BEAM_TIGHT_MASK), yb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), yb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK));
    NextPF(1, next);
    }

OpCase(i_fetch_cc):
    { 
    Eterm* next;
    PreFetch(2, next);
    FetchArgs(Arg(0), Arg(1));
    NextPF(2, next);
    }

OpCase(i_fetch_cr):
    { 
    Eterm* next;
    PreFetch(1, next);
    FetchArgs(Arg(0), r(0));
    NextPF(1, next);
    }

OpCase(i_fetch_cx):
    { 
    Eterm* next;
    PreFetch(2, next);
    FetchArgs(Arg(0), xb(Arg(1)));
    NextPF(2, next);
    }

OpCase(i_fetch_cy):
    { 
    Eterm* next;
    PreFetch(2, next);
    FetchArgs(Arg(0), yb(Arg(1)));
    NextPF(2, next);
    }

OpCase(i_fetch_rc):
    { 
    Eterm* next;
    PreFetch(1, next);
    FetchArgs(r(0), Arg(0));
    NextPF(1, next);
    }

OpCase(i_fetch_rx):
    { 
    Eterm* next;
    PreFetch(1, next);
    FetchArgs(r(0), xb(Arg(0)));
    NextPF(1, next);
    }

OpCase(i_fetch_ry):
    { 
    Eterm* next;
    PreFetch(1, next);
    FetchArgs(r(0), yb(Arg(0)));
    NextPF(1, next);
    }

OpCase(i_fetch_xc):
    { 
    Eterm* next;
    PreFetch(2, next);
    FetchArgs(xb(Arg(0)), Arg(1));
    NextPF(2, next);
    }

OpCase(i_fetch_xr):
    { 
    Eterm* next;
    PreFetch(1, next);
    FetchArgs(xb(Arg(0)), r(0));
    NextPF(1, next);
    }

OpCase(i_fetch_xx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    FetchArgs(xb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(i_fetch_xy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    FetchArgs(xb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(i_fetch_yc):
    { 
    Eterm* next;
    PreFetch(2, next);
    FetchArgs(yb(Arg(0)), Arg(1));
    NextPF(2, next);
    }

OpCase(i_fetch_yr):
    { 
    Eterm* next;
    PreFetch(1, next);
    FetchArgs(yb(Arg(0)), r(0));
    NextPF(1, next);
    }

OpCase(i_fetch_yx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    FetchArgs(yb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(i_fetch_yy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    FetchArgs(yb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(i_get_tuple_element_rPx):
    { 
    Eterm* next;
    PreFetch(2, next);
    GetTupleElement(r(0), Arg(0), xb(Arg(1)));
    NextPF(2, next);
    }

OpCase(i_get_tuple_element_xPr):
    { 
    Eterm* next;
    PreFetch(2, next);
    GetTupleElement(xb(Arg(0)), Arg(1), r(0));
    NextPF(2, next);
    }

OpCase(i_get_tuple_element_xPx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(0);
    GetTupleElement(xb(tmp_packed1&BEAM_LOOSE_MASK), Arg(1), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(2, next);
    }

OpCase(i_get_tuple_element_yPr):
    { 
    Eterm* next;
    PreFetch(2, next);
    GetTupleElement(yb(Arg(0)), Arg(1), r(0));
    NextPF(2, next);
    }

OpCase(i_get_tuple_element_yPx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(0);
    GetTupleElement(yb(tmp_packed1&BEAM_LOOSE_MASK), Arg(1), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(2, next);
    }

OpCase(i_is_eq_immed_frc):
    { 
    Eterm* next;
    PreFetch(2, next);
    EqualImmed(r(0), Arg(1), ClauseFail());
    NextPF(2, next);
    }

OpCase(i_is_eq_immed_fxc):
    { 
    Eterm* next;
    PreFetch(3, next);
    EqualImmed(xb(Arg(1)), Arg(2), ClauseFail());
    NextPF(3, next);
    }

OpCase(i_is_eq_immed_fyc):
    { 
    Eterm* next;
    PreFetch(3, next);
    EqualImmed(yb(Arg(1)), Arg(2), ClauseFail());
    NextPF(3, next);
    }

OpCase(i_put_tuple_Acr):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutTuple(Arg(0), Arg(1), r(0));
    NextPF(2, next);
    }

OpCase(i_put_tuple_Acx):
    { 
    Eterm* next;
    PreFetch(3, next);
    PutTuple(Arg(0), Arg(1), xb(Arg(2)));
    NextPF(3, next);
    }

OpCase(i_put_tuple_Anr):
    { 
    Eterm* next;
    PreFetch(1, next);
    PutTuple(Arg(0), NIL, r(0));
    NextPF(1, next);
    }

OpCase(i_put_tuple_Anx):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutTuple(Arg(0), NIL, xb(Arg(1)));
    NextPF(2, next);
    }

OpCase(i_put_tuple_Arx):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutTuple(Arg(0), r(0), xb(Arg(1)));
    NextPF(2, next);
    }

OpCase(i_put_tuple_Axr):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutTuple(Arg(0), xb(Arg(1)), r(0));
    NextPF(2, next);
    }

OpCase(i_put_tuple_Axx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(1);
    PutTuple(Arg(0), xb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(2, next);
    }

OpCase(i_put_tuple_Axy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(1);
    PutTuple(Arg(0), xb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(2, next);
    }

OpCase(i_put_tuple_Ayr):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutTuple(Arg(0), yb(Arg(1)), r(0));
    NextPF(2, next);
    }

OpCase(i_put_tuple_Ayx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(1);
    PutTuple(Arg(0), yb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(2, next);
    }

OpCase(init2_yy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    Init2(yb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)));
    NextPF(1, next);
    }

OpCase(init3_yyy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    Init3(yb(tmp_packed1&BEAM_TIGHT_MASK), yb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), yb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK));
    NextPF(1, next);
    }

OpCase(is_atom_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsAtom(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_atom_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsAtom(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_binary_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsBinary(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_binary_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsBinary(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_bitstring_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsBitstring(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_bitstring_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsBitstring(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_float_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsFloat(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_float_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsFloat(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_function2_fss):
    { Eterm targ1; Eterm targ2; 
    Eterm* next;
    PreFetch(3, next);
    GetR(1, targ1);
    GetR(2, targ2);
    IsFunction2(targ1, targ2, ClauseFail());
    NextPF(3, next);
    }

OpCase(is_function_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsFunction(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_function_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsFunction(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_function_fy):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsFunction(yb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_integer_allocate_frII):
    { 
    Eterm* next;
    PreFetch(3, next);
    IsIntegerAllocate(r(0), Arg(1), Arg(2), ClauseFail());
    NextPF(3, next);
    }

OpCase(is_integer_allocate_fxII):
    { 
    Eterm* next;
    PreFetch(4, next);
    IsIntegerAllocate(xb(Arg(1)), Arg(2), Arg(3), ClauseFail());
    NextPF(4, next);
    }

OpCase(is_integer_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsInteger(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_integer_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsInteger(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_integer_fy):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsInteger(yb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_list_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsList(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_list_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsList(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_nil_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsNil(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_nil_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsNil(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_nil_fy):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsNil(yb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_non_empty_list_test_heap_frII):
    { 
    Eterm* next;
    PreFetch(3, next);
    IsNonemptyListTestHeap(r(0), Arg(1), Arg(2), ClauseFail());
    NextPF(3, next);
    }

OpCase(is_nonempty_list_allocate_frII):
    { 
    Eterm* next;
    PreFetch(3, next);
    IsNonemptyListAllocate(r(0), Arg(1), Arg(2), ClauseFail());
    NextPF(3, next);
    }

OpCase(is_nonempty_list_allocate_fxII):
    { 
    Eterm* next;
    PreFetch(4, next);
    IsNonemptyListAllocate(xb(Arg(1)), Arg(2), Arg(3), ClauseFail());
    NextPF(4, next);
    }

OpCase(is_nonempty_list_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsNonemptyList(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_nonempty_list_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsNonemptyList(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_nonempty_list_fy):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsNonemptyList(yb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_pid_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsPid(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_pid_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsPid(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_port_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsPort(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_port_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsPort(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_reference_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsRef(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_reference_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsRef(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_tuple_fr):
    { 
    Eterm* next;
    PreFetch(1, next);
    IsTuple(r(0), ClauseFail());
    NextPF(1, next);
    }

OpCase(is_tuple_fx):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsTuple(xb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_tuple_fy):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsTuple(yb(Arg(1)), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_tuple_of_arity_frA):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsTupleOfArity(r(0), Arg(1), ClauseFail());
    NextPF(2, next);
    }

OpCase(is_tuple_of_arity_fxA):
    { 
    Eterm* next;
    PreFetch(3, next);
    IsTupleOfArity(xb(Arg(1)), Arg(2), ClauseFail());
    NextPF(3, next);
    }

OpCase(is_tuple_of_arity_fyA):
    { 
    Eterm* next;
    PreFetch(3, next);
    IsTupleOfArity(yb(Arg(1)), Arg(2), ClauseFail());
    NextPF(3, next);
    }

OpCase(move2_xyxy):
    { Uint tmp_packed1;Uint tmp_packed2;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(0);
    tmp_packed2 = Arg(1);
    Move2(xb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)), xb(tmp_packed2&BEAM_LOOSE_MASK), yb((tmp_packed2>>BEAM_LOOSE_SHIFT)));
    NextPF(2, next);
    }

OpCase(move2_yxyx):
    { Uint tmp_packed1;Uint tmp_packed2;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(0);
    tmp_packed2 = Arg(1);
    Move2(yb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), yb(tmp_packed2&BEAM_LOOSE_MASK), xb((tmp_packed2>>BEAM_LOOSE_SHIFT)));
    NextPF(2, next);
    }

OpCase(move_call_last_xrfP):
    MoveCallLast(xb(Arg(0)), r(0), Arg(1), Arg(2));

OpCase(move_call_last_yrfP):
    MoveCallLast(yb(Arg(0)), r(0), Arg(1), Arg(2));

OpCase(move_call_only_xrf):
    MoveCallOnly(xb(Arg(0)), r(0), Arg(1));

OpCase(move_call_xrf):
    MoveCall(xb(Arg(0)), r(0), Arg(1), 2);

OpCase(move_call_yrf):
    MoveCall(yb(Arg(0)), r(0), Arg(1), 2);

OpCase(move_cr):
    { 
    Eterm* next;
    PreFetch(1, next);
    Move(Arg(0), r(0), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(move_cx):
    { 
    Eterm* next;
    PreFetch(2, next);
    Move(Arg(0), xb(Arg(1)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(move_cy):
    { 
    Eterm* next;
    PreFetch(2, next);
    Move(Arg(0), yb(Arg(1)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(move_deallocate_return_crP):
    MoveDeallocateReturn(Arg(0), r(0), Arg(1));

OpCase(move_deallocate_return_nrP):
    MoveDeallocateReturn(NIL, r(0), Arg(0));

OpCase(move_deallocate_return_xrP):
    MoveDeallocateReturn(xb(Arg(0)), r(0), Arg(1));

OpCase(move_deallocate_return_yrP):
    MoveDeallocateReturn(yb(Arg(0)), r(0), Arg(1));

OpCase(move_nr):
    { 
    Eterm* next;
    PreFetch(0, next);
    Move(NIL, r(0), StoreSimpleDest);
    NextPF(0, next);
    }

OpCase(move_nx):
    { 
    Eterm* next;
    PreFetch(1, next);
    Move(NIL, xb(Arg(0)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(move_return_cr):
    MoveReturn(Arg(0), r(0));

OpCase(move_return_nr):
    MoveReturn(NIL, r(0));

OpCase(move_return_xr):
    MoveReturn(xb(Arg(0)), r(0));

OpCase(move_rx):
    { 
    Eterm* next;
    PreFetch(1, next);
    Move(r(0), xb(Arg(0)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(move_ry):
    { 
    Eterm* next;
    PreFetch(1, next);
    Move(r(0), yb(Arg(0)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(move_xr):
    { 
    Eterm* next;
    PreFetch(1, next);
    Move(xb(Arg(0)), r(0), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(move_xx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    Move(xb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(move_xy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    Move(xb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(move_yr):
    { 
    Eterm* next;
    PreFetch(1, next);
    Move(yb(Arg(0)), r(0), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(move_yx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    Move(yb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(move_yy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    Move(yb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(node_r):
    { 
    Eterm* next;
    PreFetch(0, next);
    Node(r(0));
    NextPF(0, next);
    }

OpCase(node_x):
    { 
    Eterm* next;
    PreFetch(1, next);
    Node(xb(Arg(0)));
    NextPF(1, next);
    }

OpCase(put_c):
    { 
    Eterm* next;
    PreFetch(1, next);
    Put(Arg(0));
    NextPF(1, next);
    }

OpCase(put_list_cnr):
    { 
    Eterm* next;
    PreFetch(1, next);
    PutList(Arg(0), NIL, r(0), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_cnx):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutList(Arg(0), NIL, xb(Arg(1)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_crr):
    { 
    Eterm* next;
    PreFetch(1, next);
    PutList(Arg(0), r(0), r(0), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_crx):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutList(Arg(0), r(0), xb(Arg(1)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_cry):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutList(Arg(0), r(0), yb(Arg(1)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_cxr):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutList(Arg(0), xb(Arg(1)), r(0), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_cxx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(1);
    PutList(Arg(0), xb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_cxy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(1);
    PutList(Arg(0), xb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_cyr):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutList(Arg(0), yb(Arg(1)), r(0), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_cyx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(1);
    PutList(Arg(0), yb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_cyy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(1);
    PutList(Arg(0), yb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_rcr):
    { 
    Eterm* next;
    PreFetch(1, next);
    PutList(r(0), Arg(0), r(0), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_rcx):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutList(r(0), Arg(0), xb(Arg(1)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_rcy):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutList(r(0), Arg(0), yb(Arg(1)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_rnx):
    { 
    Eterm* next;
    PreFetch(1, next);
    PutList(r(0), NIL, xb(Arg(0)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_rxr):
    { 
    Eterm* next;
    PreFetch(1, next);
    PutList(r(0), xb(Arg(0)), r(0), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_rxx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    PutList(r(0), xb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_ryx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    PutList(r(0), yb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_xcr):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutList(xb(Arg(0)), Arg(1), r(0), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_xcx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(0);
    PutList(xb(tmp_packed1&BEAM_LOOSE_MASK), Arg(1), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_xcy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(0);
    PutList(xb(tmp_packed1&BEAM_LOOSE_MASK), Arg(1), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_xnx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    PutList(xb(tmp_packed1&BEAM_LOOSE_MASK), NIL, xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_xxr):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    PutList(xb(tmp_packed1&BEAM_LOOSE_MASK), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), r(0), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_xxx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    PutList(xb(tmp_packed1&BEAM_TIGHT_MASK), xb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), xb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_xyx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    PutList(xb(tmp_packed1&BEAM_TIGHT_MASK), yb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), xb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_ycr):
    { 
    Eterm* next;
    PreFetch(2, next);
    PutList(yb(Arg(0)), Arg(1), r(0), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_ycx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(0);
    PutList(yb(tmp_packed1&BEAM_LOOSE_MASK), Arg(1), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_ycy):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(2, next);
    tmp_packed1 = Arg(0);
    PutList(yb(tmp_packed1&BEAM_LOOSE_MASK), Arg(1), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(2, next);
    }

OpCase(put_list_ynx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    PutList(yb(tmp_packed1&BEAM_LOOSE_MASK), NIL, xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_yrr):
    { 
    Eterm* next;
    PreFetch(1, next);
    PutList(yb(Arg(0)), r(0), r(0), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_yrx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    PutList(yb(tmp_packed1&BEAM_LOOSE_MASK), r(0), xb((tmp_packed1>>BEAM_LOOSE_SHIFT)), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_yxx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    PutList(yb(tmp_packed1&BEAM_TIGHT_MASK), xb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), xb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_yyr):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    PutList(yb(tmp_packed1&BEAM_LOOSE_MASK), yb((tmp_packed1>>BEAM_LOOSE_SHIFT)), r(0), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_list_yyx):
    { Uint tmp_packed1;
    Eterm* next;
    PreFetch(1, next);
    tmp_packed1 = Arg(0);
    PutList(yb(tmp_packed1&BEAM_TIGHT_MASK), yb((tmp_packed1>>BEAM_TIGHT_SHIFT)&BEAM_TIGHT_MASK), xb((tmp_packed1>>(2*BEAM_TIGHT_SHIFT))&BEAM_TIGHT_MASK), StoreSimpleDest);
    NextPF(1, next);
    }

OpCase(put_n):
    { 
    Eterm* next;
    PreFetch(0, next);
    Put(NIL);
    NextPF(0, next);
    }

OpCase(put_r):
    { 
    Eterm* next;
    PreFetch(0, next);
    Put(r(0));
    NextPF(0, next);
    }

OpCase(put_x):
    { 
    Eterm* next;
    PreFetch(1, next);
    Put(xb(Arg(0)));
    NextPF(1, next);
    }

OpCase(put_y):
    { 
    Eterm* next;
    PreFetch(1, next);
    Put(yb(Arg(0)));
    NextPF(1, next);
    }

OpCase(self_r):
    { 
    Eterm* next;
    PreFetch(0, next);
    Self(r(0));
    NextPF(0, next);
    }

OpCase(self_x):
    { 
    Eterm* next;
    PreFetch(1, next);
    Self(xb(Arg(0)));
    NextPF(1, next);
    }

OpCase(self_y):
    { 
    Eterm* next;
    PreFetch(1, next);
    Self(yb(Arg(0)));
    NextPF(1, next);
    }

OpCase(test_arity_frA):
    { 
    Eterm* next;
    PreFetch(2, next);
    IsArity(r(0), Arg(1), ClauseFail());
    NextPF(2, next);
    }

OpCase(test_arity_fxA):
    { 
    Eterm* next;
    PreFetch(3, next);
    IsArity(xb(Arg(1)), Arg(2), ClauseFail());
    NextPF(3, next);
    }

OpCase(test_arity_fyA):
    { 
    Eterm* next;
    PreFetch(3, next);
    IsArity(yb(Arg(1)), Arg(2), ClauseFail());
    NextPF(3, next);
    }

OpCase(test_heap_II):
    { 
    Eterm* next;
    PreFetch(2, next);
    TestHeap(Arg(0), Arg(1));
    NextPF(2, next);
    }

