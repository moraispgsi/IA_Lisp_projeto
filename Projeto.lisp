

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Genéricos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun existep (no lista f-algoritmo)
 	"Definir o predicado existep que permite verificar se um nó existe numa lista .
O predicado recebe três parâmetros; um nó, uma lista de nós e o nome do algoritmo.
Retorna verdadeiro se o nó existir na lista. Deve ter em atenção que para o algoritmo dfs,
o conceito de nó repetido é particular-
No algoritmo dfs um nó só é considerado igual se a sua profundidade for inferior às profundidades existentes na lista"
  (let*
      (
        (is-dfs (eql f-algoritmo 'dfs))
        (proximo-no-lista (first lista))
        (estados-iguais (equal (no-estado no) (no-estado proximo-no-lista)))
        (profundidade-superior (> (no-profundidade no) (no-profundidade proximo-no-lista)) )
        (dfs-exitep (and is-dfs estados-iguais))
        (else-existep (and (not is-dfs) estados-iguais))
      )

    (cond
      ( (null lista) nil )
      ( (and dfs-exitep profundidade-superior) t)
      ( else-existep t )
      ( t (existep no (rest lista) f-algoritmo) )
    )
  )

)

(defun existe-solucao (lista f-solucao f-algoritmo)
	"Verifica se existe uma solucao ao problema numa lista de sucessores para o algoritmo dfs"
	(cond
		((not (eql f-algoritmo 'dfs)) nil)
		((null lista) nil)
		((funcall f-solucao (car lista)) (car lista))
		(T (existe-solucao (cdr lista) f-solucao f-algoritmo))
	)
)

(defun procura-generica (no-inicial prof-max f-solucao f-sucessores f-algoritmo lista-operadores &optional (abertos (list no-inicial)) (fechados nil))
"Permite procurar a solucao de um problema usando a procura no espaço de estados. A partir de um estado inicial,
 de uma funcao que gera os sucessores e de um dado algoritmo. De acordo com o algoritmo pode ser usada um limite
 de profundidade, uma heuristica e um algoritmo de ordenacao"

 	(cond
  		((null abertos) nil); nao existe solucao ao problema
  		((funcall f-solucao (car abertos)) (car abertos)); se o primeiro dos abertos e solucao este no e devolvido
  		((existep (first abertos) fechados f-algoritmo) (procura-generica no-inicial prof-max f-solucao f-sucessores f-algoritmo lista-operadores (cdr abertos) fechados)); se o no ja existe nos fechados e ignorado
  		(T
         (let* ((lista-sucessores (funcall f-sucessores (first abertos)  lista-operadores f-algoritmo prof-max));lista dos sucessores do primeiro dos abertos
                 (solucao (existe-solucao lista-sucessores f-solucao f-algoritmo)));verifica se existe uma solucao nos sucessores para o dfs
               (cond
                   (solucao solucao); devolve a solucao
      					   (T (procura-generica no-inicial prof-max f-solucao f-sucessores f-algoritmo lista-operadores (funcall f-algoritmo (rest abertos) lista-sucessores) (cons (car abertos) fechados))); expande a arvore se o primeiro dos abertos nao for solucao
      	       )
         )
   		)
   	)
  )

(defun procura-generica-2 (no-inicial prof-max f-solucao f-sucessores f-algoritmo lista-operadores f-heuristica &optional (abertos (list no-inicial)) (fechados nil) (tempo-inicial (get-universal-time)))
"Permite procurar a solucao de um problema usando a procura no espaÃ§o de estados. A partir de um estado inicial,
 de uma funcao que gera os sucessores e de um dado algoritmo. De acordo com o algoritmo pode ser usada um limite
 de profundidade, uma heuristica e um algoritmo de ordenacao
"
	(cond
		((null abertos) nil); nao existe solucao ao problema
		((funcall f-solucao (car abertos))  (list (car abertos) (- (get-universal-time) tempo-inicial))); se o primeiro dos abertos e solucao este no e devolvido com o tempo de exe
		((existep (first abertos) fechados f-algoritmo) (procura-generica-2 no-inicial prof-max f-solucao f-sucessores f-algoritmo lista-operadores (cdr abertos) fechados)); se o no ja existe nos fechados e ignorado
		(T
			(let* ((lista-sucessores (funcall f-sucessores (first abertos)  lista-operadores f-algoritmo prof-max f-heuristica))
			      (solucao (existe-solucao lista-sucessores f-solucao f-algoritmo)));verifica se existe uma solucao nos sucessores para o dfs
		          (cond
		            (solucao (list solucao (- (get-universal-time) tempo-inicial))); devolve a solucao, com o tempo de execucao
					(T (procura-generica-2 no-inicial prof-max f-solucao f-sucessores f-algoritmo lista-operadores f-heuristica (funcall f-algoritmo (rest abertos) lista-sucessores) (cons (car abertos) fechados))); expande a arvore se o primeiro dos abertos nao for solucao
					)
			)
		)
	)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Funções auxiliares
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun substituir (i valor l)
	"Substitui um elemento de uma lista correpondente ao índice i pelo valor"
	(cond
		( (null l) nil )
		( (= i 0) (cons valor (rest l)) )
		( t (cons (first l) (substituir (1- i) valor (rest l))) )
	)
)

(defun elemento-por-indice (i l)
	"Devolve o elemento de uma lista correspondente ao índice i"
	(cond
		( (null l) nil )
		( (= i 0) (first l) )
		( t (elemento-por-indice (1- i) (rest l)) )
	)
)

(defun matriz2d-transposta (m)
	"Faz a transposta da matriz m"
	(apply  #'mapcar (cons #'list m))
)

(defun limpar-nils (lista)
	(apply #'append
		(mapcar (lambda (e)
						(cond
							((null e) nil)
							(t (list e))
						)
				) lista
		)
	)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Criação de tabuleiros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun criar-tabuleiro-vazio (n m)
	"Gera um tabuleiro vazio com n linhas e m colunas"
	(list
		(make-list (1+ n) :initial-element (make-list m))
		(make-list (1+ m) :initial-element (make-list n))
	)
)

(defun criar-tabuleiro-cheio (n m)
	"Gera um tabuleiro cheio com n linhas e m colunas"
	(list
		(make-list (1+ n) :initial-element (make-list m :initial-element T))
		(make-list (1+ m) :initial-element (make-list n :initial-element T))
	)
)


(defun tabuleiro1 ()
	"retorna um tabuleiro vazio de dimensão 3 x 3"
	(criar-tabuleiro-vazio 3 3)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Manipulação de tabuleiros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun get-arcos-horizontais (tabuleiro)
	"Retorna a lista dos arcos horizontais de um tabuleiro"
	(first tabuleiro)
)


(defun get-arcos-verticais (tabuleiro)
	"Retorna a lista dos arcos verticiais de um tabuleiro"
	(first (rest tabuleiro))
)



(defun arco-na-posicao (i lista)
	"Recebe uma lista de arcos e tenta inserir um arco na posição i"
	(cond
		((eq (elemento-por-indice (1- i) lista) T) nil)
		(t (substituir (1- i) T lista))
	)
	(substituir (1- i) T lista)
)



(defun arco-aux (x y matriz)
	"Recebe uma matriz de arcos e tenta inserir um arco na posição x y"
	(let*
		(
			(x-aux (1- x))
			(lista (elemento-por-indice x-aux matriz))
			(nova-lista (arco-na-posicao y lista))
		)
		(cond
			((null nova-lista) nil)
			(T (substituir x-aux nova-lista matriz))
		)

	)
)


(defun arco-horizontal (x y tabuleiro)
	"Recebe um tabuleiro e tenta inserir um arco na posição x y dos arcos horizontais"
	(let*
		(
			(arcos-horizontais (get-arcos-horizontais tabuleiro))
			(arcos-horizontais-resultado (arco-aux x y arcos-horizontais))
		)
		(cond
			((null arcos-horizontais-resultado) nil)
			(t (substituir 0 arcos-horizontais-resultado tabuleiro))
		)

	)
)


(defun arco-vertical (x y tabuleiro)
	"Recebe um tabuleiro e tenta inserir um arco na posição x y dos arcos verticais"
	(let*
		(
			(arcos-verticais (get-arcos-verticais tabuleiro))
			(arcos-verticais-resultado (arco-aux x y arcos-verticais))
		)
		(cond
			( (null arcos-verticais-resultado) nil)
			( t (substituir 1 arcos-verticais-resultado tabuleiro) )
		)
	)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Operadores
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun criar-operacao (x y funcao)
	"Cria uma função lambda que representa uma operação através de uma operação (arco-horizontal/arco-vertical) e a posição x e y"
	(lambda (tabuleiro) (funcall funcao x y tabuleiro))
)


(defun criar-operacoes-decrementarY (x y funcao)
	"Decrementa o valor de y recursivamente e vai criando operações com o valor de x e y e a função"
	(cond
		( (= y 0) nil )
		( t (cons (criar-operacao x y funcao) (criar-operacoes-decrementarY x (1- y) funcao)) )
	)
)


(defun criar-operacoes-decrementarX (x y funcao)
	"Decrementa o valor de x recursivamente e vai chamando a função 'criar-operacoes-decrementarY' com o valor de x e y e a funcao"
	(cond
		( (= x 0) nil )
		( t (append (criar-operacoes-decrementarY x y funcao) (criar-operacoes-decrementarX (1- x) y funcao)) )
	)
)


(defun criar-operacoes (n m)
	"Gera todos os operadores possíveis para um tabuleiro de n por m"
	(append
		(criar-operacoes-decrementarX (1+ n) m 'arco-horizontal)
		(criar-operacoes-decrementarX (1+ m) n 'arco-vertical)
	)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Testes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun aplicar-consecutivamente (tabuleiro operacoes)
	"Aplica um conjunto de operações consecutivas a um tabuleiro"
	(cond
		( (null operacoes) tabuleiro )
		( t (aplicar-consecutivamente (funcall (first operacoes) tabuleiro) (rest operacoes)) )
	)
)

(defun teste-preecher (n m)
	"Realiza um teste que gera todos os operadores possiveis e os aplica num tabuleiro n por m consecutivo, com objetivo a preecher todo o tabuleiro com arcos"
	(let
		(
			(operacoes (criar-operacoes n m))
			(tabuleiro (criar-tabuleiro-vazio n m))
		)
		(aplicar-consecutivamente tabuleiro operacoes)
	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Classificação do tabuleiro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;TODO refactoring (está muito grande, repartir em mais funções) testar no final
(defun numero-caixas-fechadas (tabuleiro)
	"Devolve o número fechadas num tabuleiro"
	(apply 	'+
			(mapcar
				(lambda (&rest l1)
						(apply 	'+
								(mapcar #'
										(lambda (&rest l2)
												(cond
													((eval (cons 'and l2)) 1)
													(t 0)
												)
										)
										(first l1)
										(first (rest l1))
								)

						)
				)
				(matriz2d-transposta (get-arcos-horizontais tabuleiro))
				(matriz2d-transposta (get-arcos-verticais tabuleiro))
			)
	)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Manipulação de nós
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun no-criar (estado &optional (pai nil) (profundidade 0) (controlo nil))
  "Cria um nó"
  (list estado pai profundidade controlo)
)


(defun no-estado (node)
	"Devolve o estado do nó"
	(elemento-por-indice 0 node)
)

(defun no-pai (node)
	"Devolve o pai do nó"
	(elemento-por-indice 1 node)
)

(defun no-profundidade (node)
	"Devolve a profundidade do nó"
	(elemento-por-indice 2 node)
)

(defun no-controlo (node)
	(elemento-por-indice 3 node)
)



(defun no-alterar-estado (node estado)
 "Altera o estado de um nó"
  (substituir 0 estado node)
)

(defun set-node-pai (node pai)
 "Altera o pai do nó"
  (substituir 1 pai node)
)

(defun set-node-controlo (node controlo)
 "Altera o pai do nó"
  (substituir 2 controlo node)
)



(defun no-controlo-g (node)
  "Devolve o g do nó"
  (elemento-por-indice 0 (no-controlo node))
)

(defun no-controlo-h (node)
  "Devolve o h do nó"
  (elemento-por-indice 1 (no-controlo node))
)

(defun no-controlo-f (node)
  "Devolve o f do nó"
  (elemento-por-indice 2 (no-controlo node))
)

(defun set-node-g (node g)
	"Altera o valor g do nó"
	(set-node-controlo node (substituir 0 g (no-controlo node)))
)

(defun set-node-h (node h)
	"Altera o valor h do nó"
	(set-node-controlo node (substituir 1 h (no-controlo node)))
)

(defun set-node-f (node f)
	"Altera o valor f do nó"
	(set-node-controlo node (substituir 2 f (no-controlo node)))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ordenação
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;f-algoritmo
(defun bfs (abertos sucessores)
	""
	(append abertos sucessores)
)


(defun dfs (abertos sucessores)
	""
	(append sucessores abertos)
)

(defun a-asterisco (abertos sucessores)
	(stable-sort (append abertos sucessores) (lambda (x) (no-controlo-f x)))
)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sucessores
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun sucessores (no lista-operadores f-algoritmo prof-max)
	"Gera os sucessores"
	(cond
		( (and (eql f-algoritmo 'dfs) (>= (no-profundidade no) prof-max)) nil)
		( t (let*
				(
					(nova-profundidade (1+ (no-profundidade no)))
					(funcao (lambda (op) (no-criar (funcall op no) no nova-profundidade)))
				)
				(limpar-nils (mapcar funcao lista-operadores))
			)
		)
	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Heurísticas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun f-solucao (o)
  (lambda (no) (= (numero-caixas-fechadas no) o))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Heurísticas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun a (tabuleiro o)
	(- o (numero-caixas-fechadas tabuleiro) 1)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Testes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun teste-bfs (n m o)
   (procura-generica (no-criar (criar-tabuleiro-vazio n m)) nil (f-solucao o) 'sucessores 'bfs (criar-operacoes n m))
)
