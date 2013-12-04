(load "meta.scm")
(load "matche.scm")

(defrel (!-o)
  !-o-clause
  (!-o gamma expr type)
  (matche (expr type)
    ((,x ,T) (symbolo x) (lookupo `(,x : ,T) gamma))
    (((lambda (,x) ,e) (,T1 -> ,T2))
     (!-o `((,x : ,T1) . ,gamma) e T2))
    (((,e1 ,e2) ,T)
     (fresh (T1)
       (!-o gamma e1 `(,T1 -> ,T))
       (!-o gamma e2 T1)))))

(define (lookupo binding rho)
  (matche (binding rho)
    (((,x : ,v) ((,x : ,v) . ,_)))
    (((,x : ,v) ((,y : ,_) . ,rho1)) (=/= x y) (lookupo binding rho1))))

