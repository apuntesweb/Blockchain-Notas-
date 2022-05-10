// Llamada al contrato
const notas = artifacts.require("Notas");

contract("Notas", (accounts) => {
    it("1. Funcion Evaluar(string memory _idAlumno, uint _nota)", async () => {
        // Smart Contract desplegado
        let instance = await notas.deployed();
        // Llamada al metodo de evaluacion del Smart Contract
        const tx1 = await instance.Evaluar("12345X", 9, { from: accounts[0] });
        const tx2 = await instance.Evaluar("77755N", 5, { from: accounts[0] });
        // Imprimir valores
        console.log(accounts[0]); // Direccion del profesor
        console.log(tx1); // Transaccion de la evaluacion academica
        console.log(tx2); // Transaccion de la evaluacion academica
        // Comprobacion de la informacion de la Blockchain
        const nota_alumno = await instance.VerNotas.call("12345X", { from: accounts[1] });
        // Condicion para pasar el test: que la nota alumno = 9
        console.log(nota_alumno);
        assert.equal(nota_alumno, 9);
    });
    
    it("2. Revision(string memory _idAlumno)", async () => {
        // Smart Contract desplegado
        let instance = await notas.deployed();
        // Llamada al metodo de revision de notas
        const rev1 = await instance.Revision("12345X", { from: accounts[1] });
        const rev2 = await instance.Revision("77755N", { from: accounts[1] });
        // Imprimir los valores recibidos de la revision
        console.log(rev1);
        console.log(rev2);
        const id_alumno = await instance.VerRevisiones.call({ from: accounts[0] });
        console.log(id_alumno);
        // Comprobacion de los datos de las revisiones
        assert.equal(id_alumno[0], "12345X");
        assert.equal(id_alumno[1], "77755N");

    });
});
