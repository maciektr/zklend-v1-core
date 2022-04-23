# SPDX-License-Identifier: BUSL-1.1

%lang starknet

from zklend.libraries.SafeMath import SafeMath_add, SafeMath_div, SafeMath_mul, SafeMath_sub

@view
func add{range_check_ptr}(a : felt, b : felt) -> (res : felt):
    with_attr error_message("add failed"):
        return SafeMath_add(a, b)
    end
end

@view
func sub{range_check_ptr}(a : felt, b : felt) -> (res : felt):
    with_attr error_message("sub failed"):
        return SafeMath_sub(a, b)
    end
end

@view
func mul{range_check_ptr}(a : felt, b : felt) -> (res : felt):
    with_attr error_message("mul failed"):
        return SafeMath_mul(a, b)
    end
end

@view
func div{range_check_ptr}(a : felt, b : felt) -> (res : felt):
    with_attr error_message("div failed"):
        return SafeMath_div(a, b)
    end
end