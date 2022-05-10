// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

// --------------------------------------------
// ALUMNO   /   ID      /   NOTA
// --------------------------------------------
//  Marcos  /   77755N  /   5
//  Joan    /   12345X  /   9
//  Maria   /   02468T  /   2
//  Mata    /   13579U  /   3
//  Alba    /   98765Z  /   5

contract notas {
    // Direccion del Profesor
    address public profesor;

    // Constructor
    constructor () public {
        profesor = msg.sender;
    }

    // Mapping para relacionar el hash de la identidad del alumno con su nota del examen
    mapping(bytes32 => uint256) Notas;

    // Mapping de los alumnos que pidan revisiones de examen para una asignatura
    mapping (string => string []) revisiones;

    // Eventos
    event alumno_evaluado(bytes32);
    event alumno_revision(string);
    event evento_revision(string);

    // funcion para evaluar a alimnos
    function Evaluar(string memory _asignatura, string memory _idAlumno, uint256 _nota) public UnicamenteProfesor(msg.sender) {
        // Hash de la identificacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_asignatura, _idAlumno));
        // Relacion entre el hash de la identificacion del alumno y su nota
        Notas[hash_idAlumno] = _nota;
        // Emision del evento
        emit alumno_evaluado(hash_idAlumno);
    }

    // Control de las funciones ejecutables por el profesor
    modifier UnicamenteProfesor(address _direccion) {
        // Requiere que la introduccion introducida por parametro sea igual al owner del contrato
        require(
            _direccion == profesor,
            "No tienes permisos para ejecutar esta funcion"
        );
        _;
    }

    // Funcion para ver las notas de un alumno
    function VerNotas(string memory _asignatura, string memory _idAlumno) public view returns (uint256) {
        // Hash de la identificacion del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_asignatura, _idAlumno));
        // Nota asociada al hash del alumno
        uint256 nota_alumno = Notas[hash_idAlumno];
        // Visualizar la nota
        return nota_alumno;
    }

    // Funcion para pedir revision del examen
    function Revision(string memory _asignatura, string memory _idAlumno) public {
        // Almacenamiento de la identidad del alumno en un array
        revisiones[_asignatura].push(_idAlumno);
        // Emision del evento
        emit evento_revision(_idAlumno);
    }

    // Funcion para ver quien ha pedido revision del examen
    function VerRevisiones(string memory _asignatura) public view UnicamenteProfesor(msg.sender) returns (string[] memory) {
        // Devolver las identidades de los alumnos que han solicitado revision
        return revisiones[_asignatura];
    }
}
