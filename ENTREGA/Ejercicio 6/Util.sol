// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

library Util {
    // Return the total days since Unix epoch based on the input
    function dateToTimestamp(string memory customDate) public pure returns(uint) {
        int year = int(numberSubstring(customDate, 0, 4));
        int month = int(numberSubstring(customDate, 5, 7));
        int day = int(numberSubstring(customDate, 8, 10));

        require(year >= 1970, "El a\xc3\xb1o no puede ser menor a 1970");
        require(month >= 1 && month <= 12, "El mes es inv\xc3\xa1lido debe ser un valor entre 01 a 12");
        require(day >= 1 && day <= 31, "El d\xc3\xada es inv\xc3\xa1lido debe ser un valor entre 01 a 31");

        int offset = 2440588;

        int totalDays = day - 32075 + 1461 * (year + 4800 + (month - 14) / 12) / 4
            + 367 * (month - 2 - (month - 14) / 12 * 12) / 12
            - 3 * ((year + 4900 + (month - 14) / 12) / 100) / 4
            - offset;

        return uint(totalDays);
    }

    // Return the current date in the format of total days since Unix epoch
    function currentDate() public view returns(uint) {
        uint epoch_time = block.timestamp;
        return epoch_time / (24 * 60 * 60);
    }

    function numberSubstring(string memory _str, uint _startIndex, uint _endIndex) public pure returns (uint) {
        bytes memory strBytes = bytes(_str);
        bytes memory result = new bytes(_endIndex - _startIndex);
        for(uint i = _startIndex; i < _endIndex; i++) {
            result[i - _startIndex] = strBytes[i];
        }
        return parseInt(result);
    }

    function parseInt(bytes memory _value) public pure returns (uint) {
        bytes memory b = bytes(_value);
        uint i;
        uint result = 0;

        for (i = 0; i < b.length; i++) {
            uint c = uint(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }

        return result;
    }
}
