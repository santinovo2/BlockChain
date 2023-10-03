// SPDX-License-Identifier: GPL-3.0
pragma solidity >0.8.0;

contract FabricaContract {
    
    uint idDigits = 16;

    struct Producto{

        string nombre;
        uint identificacion;
    }

    Producto [] public productos;

    function crearProducto(string memory _nombre , uint _id) private {

        Producto memory producto = Producto (_nombre, _id);

        productos.push(producto);

        emit NuevoProducto(productos.length, _nombre, _id);
    }

    function _generarIdAleatorio (string memory _str) private view returns (uint){

        uint rand;

        rand = uint(keccak256(abi.encodePacked(_str)));

        uint idModulus = 10^idDigits;
        rand = rand % idModulus;

        return rand;
    }

    function crearProductoAleatorio(string memory _nombre) public{
       
        uint randId = _generarIdAleatorio(_nombre);
        crearProducto(_nombre, randId);
    }

    event NuevoProducto (uint ArrayProductoId, string nombre, uint id);

    mapping (uint => address) public productoAPropietario;
    //mapping (clave => valor)

    mapping (address => uint) public propietarioProductos;

    function Propiedad(uint _productId) public {

        productoAPropietario[_productId] = msg.sender;
        propietarioProductos[msg.sender]++;
    }

    function getProductosPorPropietario(address _propietario) view external returns (uint [] memory) {

        uint numProduct;
        uint contador = 0;
        
        numProduct = propietarioProductos[_propietario];
        uint[] memory resultado = new uint [](numProduct);
        

       for(uint i = 0; i < productos.length; i++){

        uint identificacion = productos[i].identificacion;

            if(productoAPropietario[identificacion] == _propietario){
                resultado[contador] = productos[i].identificacion;
                contador++;
            }
        

       }
       
       return resultado;
    }

}