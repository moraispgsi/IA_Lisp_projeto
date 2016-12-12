;; tronco comum


(defun verificar-n-arcos-faltam (caixa n)
  (cond
   ((= n (- 4 (apply '+ caixa))) 1)
   (t 0)
   )
  )

;; parte dos numeros de caixas com n linhas a faltar

(defun n-caixas-a-faltar-x-arcos(caixas n)
  (apply
   '+
   (mapcar
    (lambda (x)
      (apply '+
             ( mapcar
               (lambda (z)
                 (verificar-n-arcos-faltam z n))
               x )
             )
      )
    caixas)
   )

  )


;;parte das partilhas


(defun h-numero-partilhas-horizonta-duas-linhas-quadrados(linha1 linha2 n1 n2)

  (apply '+

         (mapcar
          (lambda(x y)
            (cond
             ((and (= 1 (verificar-n-arcos-faltam x n1)) (= 1 (verificar-n-arcos-faltam y n2)))
              (cond
               ((and (= (second x) (first y)) (= 0 (second x))) 1)
               (T 0)
               )
              )
             (T 0)
             )

            )
          linha1 linha2
          )

         )

  )


(defun h-numero-partilhas-vertical (linha n1 n2)

  (cond
   ((null linha) 0)
   ((null (second linha)) 0)
   ((and (= 0 (third (first linha))) (= (third (first linha)) (fourth (second linha)) ) )

    (cond
     ((and (= 1 (verificar-n-arcos-faltam (first linha) n1)) (= 1 (verificar-n-arcos-faltam (second linha) n2)))
      (+ 1 (h-numero-partilhas-vertical (cdr linha) n1 n2)) )
     (T
      (h-numero-partilhas-vertical (cdr linha) n1 n2)))
    )
   (T (h-numero-partilhas-vertical (cdr linha) n1 n2)))

)


(defun aux-partilhas-vertical(caixas n1 n2)

  (cond
   ((null caixas) 0)
   (T (+ (h-numero-partilhas-vertical (first caixas) n1 n2) (aux-partilhas-vertical (rest caixas) n1 n2) ))
   )
  )

(defun aux-partilhas-horizontal(caixas n1 n2)
  (cond
   ((null caixas) 0)
   ((null (second caixas)) 0)
   (T (+ (h-numero-partilhas-horizonta-duas-linhas-quadrados (first caixas) (second caixas) n1 n2 ) (aux-partilhas-horizontal (rest caixas) n1 n2)))

   )

  )


;; a funÃ§Ã£o que faz mesmo o calculo total
(defun calcurar-n-partilhas-n1-n2 (caixas n1 n2)
  (cond
   ((= n1 n2)
    (+ (aux-partilhas-horizontal caixas n1 n2) (aux-partilhas-vertical caixas n1 n2 ))
    )
   ( T
     (+ (+ (aux-partilhas-horizontal caixas n1 n2) (aux-partilhas-vertical caixas n1 n2)) (+ (aux-partilhas-horizontal caixas n2 n1) (aux-partilhas-vertical caixas n2 n1)))
     )
   )
  )


;; helpers


  (defun get-helper()

  '( ((0 0 1 0) (0 0 1 1)) ((0 0 1 0)(0 0 1 1)) )
  )
  (defun get-helper2()

  '( ((1 1 0 0) (1 1 0 0) (1 1 0 0)) ((1 1 0 0)(1 1 0 0) (1 1 0 0)) ((1 1 0 0)(1 1 0 0) (0 0 0 0))  )
  )


(defun get-helper3()

  '(
    ( (0 0 1 0) (1 1 1 1) (0 1 0 1))
    ( (0 0 1 0) (1 0 0 1) (1 1 0 0))
    ( (0 0 1 0) (0 0 0 1) (1 0 0 0))
     )
)


(defun convert-top-bottom(linha)
  (cond
   ((null (second linha)) nil)
   (T
    (cons (mapcar 'list (first linha) (second linha))  (convert-top-bottom (rest linha)))
    )
   )
  )

(defun tabuleiro-c ()
	'(((nil nil t nil)(t nil t t)(nil nil t t)(nil nil t t)(nil nil t t))
	((nil nil t t)(nil nil t t)(nil nil t t)(t nil t t)(nil t t t)))
)
(defun matriz2d-transposta (m)
	"Faz a transposta da matriz m"
	(apply  #'mapcar (cons #'list m))
)

(defun converter-tabuleiro(tabuleiro)
  (mapcar 'converter-aux (convert-top-bottom (car tabuleiro)) (matriz2d-transposta (convert-top-bottom (car (rest tabuleiro)))) )
)

(defun converter-aux(tops-bottoms lefts-rights)

  (mapcar
   (lambda (x y)
     (append x (reverse y))
     )
   tops-bottoms lefts-rights
   )

  )


(defun tabuleiro-e ()
	'(((nil nil nil t nil nil)(nil nil nil t t t)(t t t t t nil)(nil nil nil t t nil)(nil nil nil t t nil)(nil nil t t t t)(nil nil t t t t))
	((nil nil nil t t t)(nil t nil nil t t)(nil t t nil t t)(nil nil t t nil nil)(t nil t nil t nil)(nil nil t t nil nil)(nil t t t t t)))
)


(defun mapear-para-binario (matriz)

  (cond
   ((null matriz) nil)
   (T (cons (mapcar 'mapear-bool-binario (first matriz) ) (mapear-para-binario (rest matriz))))
   )
  )


(defun mapear-bool-binario (matriz)
	(mapcar
		(lambda
			(elemento)
			(cond
				(elemento 1)
				(t 0)
			)
		)
		matriz
	)
)


(defun estrutura-test()
(mapear-para-binario (converter-tabuleiro (tabuleiro-c)))

)
