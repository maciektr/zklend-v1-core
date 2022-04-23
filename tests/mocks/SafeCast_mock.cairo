# SPDX-License-Identifier: BUSL-1.1

%lang starknet

from zklend.libraries.SafeCast import (
    SafeCast_felt_to_uint256,
    SafeCast_uint256_to_felt,
    SafeCast_uint256_to_felt_unchecked,
)

from starkware.cairo.common.uint256 import Uint256

@view
func felt_to_uint256{range_check_ptr}(value : felt) -> (res : Uint256):
    with_attr error_message("felt_to_uint256 failed"):
        return SafeCast_felt_to_uint256(value)
    end
end

@view
func uint256_to_felt{range_check_ptr}(value : Uint256) -> (res : felt):
    with_attr error_message("uint256_to_felt failed"):
        return SafeCast_uint256_to_felt(value)
    end
end

@view
func uint256_to_felt_unchecked{range_check_ptr}(value : Uint256) -> (res : felt):
    with_attr error_message("uint256_to_felt_unchecked failed"):
        return SafeCast_uint256_to_felt_unchecked(value)
    end
end