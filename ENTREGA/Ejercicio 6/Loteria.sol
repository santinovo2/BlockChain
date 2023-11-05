// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./Util.sol";

contract Loteria {
    using Util for *;

    address public administrador;
    address public ganador;
    uint public fechaLimite;
    uint public premioAcumulado;
    address[] public participantes;

    constructor(string memory _fechaLimite) {
        administrador = msg.sender;
        fechaLimite = Util.dateToTimestamp(_fechaLimite);
        premioAcumulado = 0;
    }

    modifier validacionSorteo() {
        require(msg.sender == administrador, "Solo el administrador puede realizar el sorteo");
        require(ganador == address(0) , "Ya existe un ganador");
        require(Util.currentDate() >= fechaLimite, "El sorteo solo puede realizarse despues de la fecha limite");
        require(participantes.length > 0, "No hay participantes");
        _;
    }

    modifier validarCompraBoleto() {
        require(msg.value == 1 ether, "El boleto cuesta 1 ether");
        require(Util.currentDate() < fechaLimite, "La fecha limite para comprar boletos ha pasado");
        _;
    }

    function comprarBoleto() public payable validarCompraBoleto() {
        participantes.push(msg.sender);
        premioAcumulado += msg.value;
    }

    function realizarSorteo() public validacionSorteo() {
        uint indiceGanador = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participantes))) % participantes.length;
        ganador = participantes[indiceGanador];
        payable(ganador).transfer(premioAcumulado);
        premioAcumulado = 0;
    }

    function obtenerGanador() public view returns (address) {
        return ganador;
    }

}
