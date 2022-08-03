// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract ExternalContract {
    function returnMsgSender() external view returns(address) {
        return msg.sender;
    }
}


contract ExternalContractInheritor is ExternalContract {
    ExternalContract _externalContract;
    
    function deployExternalContract() public {
        _externalContract = new ExternalContract();
    }
    
    function callExternalContractFuncton() external view returns(address) {
        return _externalContract.returnMsgSender();
    }
}


contract ExternalContractImporter {
    ExternalContract _externalContract;

    function deployExternalContract() public {
        _externalContract = new ExternalContract();
    }

    function callExternalContractFuncton() public view returns(address) {
        return _externalContract.returnMsgSender();
    }
}
