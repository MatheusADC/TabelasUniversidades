CREATE TABLE Pessoas(
	codPessoa INT UNSIGNED NOT NULL AUTO_INCREMENT,
	nome VARCHAR(50) NOT NULL,
	dataNascimento DATE NOT NULL,
	email VARCHAR(100),
	dataCadastro DATE NOT NULL,
	codAdm INT UNSIGNED,
	CONSTRAINT Pessoas_PK PRIMARY KEY (codPessoa)
)ENGINE=INNODB;

CREATE TABLE Administrativo(
	codAdm INT UNSIGNED NOT NULL,
	setor VARCHAR(40) NOT NULL,
	CONSTRAINT Administrativo_PK PRIMARY KEY (codAdm),
	CONSTRAINT Administrativo_FK FOREIGN KEY (codAdm)
		REFERENCES Pessoas (codPessoa)
)ENGINE=INNODB;

INSERT INTO Pessoas (codPessoa, nome, dataNascimento, email, dataCadastro, codAdm) VALUES (1, 'System', NOW(), null, NOW(), null);

INSERT INTO Administrativo (codAdm, setor) VALUES (1, 'System');

ALTER TABLE Pessoas ADD CONSTRAINT Pessoas_FK
FOREIGN KEY (codAdm) REFERENCES Administrativo (codAdm);

CREATE TABLE CEPS(
	codCEP INT UNSIGNED NOT NULL AUTO_INCREMENT,
	CEP CHAR(8) NOT NULL,
	cidade VARCHAR(40) NOT NULL,
	UF CHAR(2) NOT NULL,
	CONSTRAINT CEPS_PK PRIMARY KEY (codCEP)
)ENGINE=INNODB;

CREATE TABLE Disciplinas(
	codDisciplina INT UNSIGNED NOT NULL AUTO_INCREMENT,
	nomeDisciplina VARCHAR(40) NOT NULL,
	ementa VARCHAR(500) NOT NULL,
	creditos TINYINT UNSIGNED,
	cargaHoraria TINYINT UNSIGNED,
	preRequisito INT UNSIGNED NOT NULL,
	CONSTRAINT Disciplinas_PK PRIMARY KEY (codDisciplina),
	CONSTRAINT Disciplinas_FK FOREIGN KEY (preRequisito)
		REFERENCES Disciplinas (codDisciplina)
)ENGINE=INNODB;

CREATE TABLE Enderecos(
	codPessoa INT UNSIGNED NOT NULL AUTO_INCREMENT,
	rua VARCHAR(30),
	numero INT UNSIGNED NOT NULL,
	bairro VARCHAR(30),
	codCEP	INT UNSIGNED NOT NULL,
	CONSTRAINT Enderecos_PK PRIMARY KEY (codPessoa),
	CONSTRAINT Enderecos_FK FOREIGN KEY (codCEP)
		REFERENCES CEPS (codCEP)
)ENGINE=INNODB;

CREATE TABLE Telefones(
	codPessoa INT UNSIGNED NOT NULL AUTO_INCREMENT,
	numero CHAR(13) NOT NULL,
	CONSTRAINT Telefones_PK PRIMARY KEY (codPessoa),
	CONSTRAINT Telefones_FK FOREIGN KEY (codPessoa)
		REFERENCES Pessoas (codPessoa)
)ENGINE=INNODB;

CREATE TABLE Professores(
	codProfessor INT UNSIGNED NOT NULL AUTO_INCREMENT,
	departamento VARCHAR(50) NOT NULL,
	maiorTitulo VARCHAR(50),
	CONSTRAINT Professores_PK PRIMARY KEY (codProfessor),
	CONSTRAINT Professores_FK FOREIGN KEY (codProfessor)
		REFERENCES Pessoas (codPessoa)
)ENGINE=INNODB;

CREATE TABLE Alunos(
	codAluno INT UNSIGNED NOT NULL AUTO_INCREMENT,
	carteiraEstudante INT UNSIGNED NOT NULL,
	CONSTRAINT Alunos_PK PRIMARY KEY (codAluno),
	CONSTRAINT Alunos_FK FOREIGN KEY (codAluno)
		REFERENCES Pessoas (codPessoa)
)ENGINE=INNODB;

CREATE TABLE Cursos(
	codCurso INT UNSIGNED NOT NULL AUTO_INCREMENT,
	nomeCurso VARCHAR(40) NOT NULL,
	duracao TINYINT UNSIGNED NOT NULL,
	grandeArea VARCHAR(40),
	coordenador INT UNSIGNED NOT NULL,
	CONSTRAINT Cursos_PK PRIMARY KEY (codCurso),
	CONSTRAINT Cursos_FK FOREIGN KEY (coordenador)
		REFERENCES Professores (codProfessor)
)ENGINE=INNODB;

CREATE TABLE Turmas(
	codTurma INT UNSIGNED NOT NULL AUTO_INCREMENT,
	codDisciplina INT UNSIGNED NOT NULL,
	codProfessor INT UNSIGNED NOT NULL,
	ano INT UNSIGNED,
	semestre TINYINT UNSIGNED,
	CONSTRAINT Turmas_PK PRIMARY KEY (codTurma),
	CONSTRAINT Turmas_FK1 FOREIGN KEY (codDisciplina)
		REFERENCES Disciplinas (codDisciplina),
	CONSTRAINT Turmas_FK2 FOREIGN KEY (codProfessor)
		REFERENCES Professores (codProfessor)
)ENGINE=INNODB;

CREATE TABLE CursosDisciplinas(
	codCurso INT UNSIGNED NOT NULL,
	codDisciplina INT UNSIGNED NOT NULL,
	CONSTRAINT CursosDisciplinas_PK PRIMARY KEY (codCurso, codDisciplina),
	CONSTRAINT CursosDisciplinas_FK1 FOREIGN KEY (codCurso)
		REFERENCES Cursos (codCurso),
	CONSTRAINT CursosDisciplinas_FK2 FOREIGN KEY (codDisciplina)
		REFERENCES Disciplinas (codDisciplina)
)ENGINE=INNODB;

CREATE TABLE CursosAlunos(
	codCurso INT UNSIGNED NOT NULL,
	codAluno INT UNSIGNED NOT NULL,
	CONSTRAINT CursosAlunos_PK PRIMARY KEY (codCurso, codAluno),
	CONSTRAINT CursosAlunos_FK1 FOREIGN KEY (codCurso)
		REFERENCES Cursos (codCurso),
	CONSTRAINT CursosAlunos_FK2 FOREIGN KEY (codAluno)
		REFERENCES Alunos (codAluno)
)ENGINE=INNODB;

CREATE TABLE Aulas(
	codAula INT UNSIGNED NOT NULL AUTO_INCREMENT,
	conteudo VARCHAR(50) NOT NULL,
	dataAula DATETIME,
	codTurma INT UNSIGNED NOT NULL,
	CONSTRAINT Aulas_PK PRIMARY KEY (codAula),
	CONSTRAINT Aulas_FK FOREIGN KEY (codTurma)
		REFERENCES Turmas (codTurma)
)ENGINE=INNODB;

CREATE TABLE Participacoes(
	codPart INT UNSIGNED NOT NULL AUTO_INCREMENT,
	codAluno INT UNSIGNED NOT NULL,
	codTurma INT UNSIGNED NOT NULL,
	media FLOAT,
	CONSTRAINT Participacoes_PK PRIMARY KEY (codPart),
	CONSTRAINT Participacoes_FK1 FOREIGN KEY (codTurma)
		REFERENCES Turmas (codTurma),
	CONSTRAINT Participacoes_FK2 FOREIGN KEY (codAluno)
		REFERENCES Alunos (codAluno)
)ENGINE=INNODB;

CREATE TABLE Presencas(
	codAula INT UNSIGNED NOT NULL,
	codPart INT UNSIGNED NOT NULL,
	faltas TINYINT UNSIGNED NOT NULL,
	CONSTRAINT Presencas_PK PRIMARY KEY (codAula, codPart),
	CONSTRAINT Presencas_FK1 FOREIGN KEY (codAula)
		REFERENCES Aulas (codAula),
	CONSTRAINT Presencas_FK2 FOREIGN KEY (codPart)
		REFERENCES Participacoes (codPart)
)ENGINE=INNODB;

CREATE TABLE Avaliacoes(
	codAvaliacao INT UNSIGNED NOT NULL AUTO_INCREMENT,
	dataAvaliacao DATE,
	codTurma INT UNSIGNED NOT NULL,
	peso FLOAT,
	notaMaxima FLOAT,
	CONSTRAINT Avaliacoes_PK PRIMARY KEY (codAvaliacao),
	CONSTRAINT Avaliacoes_FK FOREIGN KEY (codTurma)
		REFERENCES Turmas (codTurma)
)ENGINE=INNODB;

CREATE TABLE AvaliacoesPart(
	codAvaliacao INT UNSIGNED NOT NULL,
	codPart INT UNSIGNED NOT NULL,
	nota FLOAT,
	observacao VARCHAR(200),
	CONSTRAINT AvaliacoesPart_PK PRIMARY KEY (codAvaliacao, codPart),
	CONSTRAINT AvaliacoesPart_FK1 FOREIGN KEY (codAvaliacao)
		REFERENCES Avaliacoes (codAvaliacao),
	CONSTRAINT AvaliacoesPart_FK2 FOREIGN KEY (codPart)
		REFERENCES Participacoes (codPart)
)ENGINE=INNODB;
