# SPDX-License-Identifier: BUSL-1.1

%lang starknet

from zklend.interfaces.IZToken import IZToken

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address

from openzeppelin.token.erc20.interfaces.IERC20 import IERC20
from openzeppelin.utils.constants import TRUE

#
# Structs
#

struct ReserveData:
    member enabled : felt
    member z_token_address : felt
end

#
# Storage
#

@storage_var
func reserves(token : felt) -> (res : ReserveData):
end

#
# External
#

@external
func deposit{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    token : felt, amount : Uint256
):
    let (caller) = get_caller_address()
    let (this_address) = get_contract_address()

    #
    # Checks
    #
    let (reserve) = reserves.read(token)
    with_attr error_message("Market: reserve not enabled"):
        assert_not_zero(reserve.enabled)
    end

    #
    # Interactions
    #

    # Takes token from user
    let (transfer_success) = IERC20.transferFrom(
        contract_address=token, sender=caller, recipient=this_address, amount=amount
    )
    with_attr error_message("Market: transferFrom failed"):
        assert_not_zero(transfer_success)
    end

    # Mints ZToken to user. No need to check return value as ZToken throws on failure
    IZToken.mint(contract_address=reserve.z_token_address, to=caller, amount=amount)

    return ()
end

# TODO: make function permissioned
@external
func add_reserve{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    token : felt, z_token : felt
):
    #
    # Checks
    #
    with_attr error_message("Market: zero token"):
        assert_not_zero(token)
    end
    with_attr error_message("Market: zero z_token "):
        assert_not_zero(z_token)
    end

    let (existing_reserve) = reserves.read(token)
    with_attr error_message("Market: reserve already exists"):
        assert existing_reserve.z_token_address = 0
    end

    #
    # Effects
    #
    let new_reserve = ReserveData(enabled=TRUE, z_token_address=z_token)
    reserves.write(token, new_reserve)

    return ()
end
