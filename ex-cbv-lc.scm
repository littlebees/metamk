(define evalo
  (lambda (expr val)
    (eval-expo expr '() val)))

(define-rel (l== x y)
  ((l==-clause ==))
  ()
  (== x y))

(define-rel (eval-expo expr env val)
  ((eval-expo-clause eval-expo not-in-envo lookupo == l== symbolo))
  ()
  (conde
    ((fresh (rator rand x body env^ a)
       (== `(,rator ,rand) expr)
       (eval-expo rator env `(closure ,x ,body ,env^))
       (eval-expo rand env a)
       (eval-expo body `((,x . ,a) . ,env^) val)))
    ((fresh (x body)
       (== `(lambda (,x) ,body) expr)
       (symbolo x)
       (l== `(closure ,x ,body ,env) val)
       (not-in-envo 'lambda env)))
    ((symbolo expr) (lookupo expr env val))))

(define-rel (not-in-envo x env)
  ((not-in-envo-clause not-in-envo == =/=))
  ()
  (conde
    ((== '() env))
    ((fresh (y v rest)
       (== `((,y . ,v) . ,rest) env)
       (=/= y x)
       (not-in-envo x rest)))))

(define-rel (lookupo x env t)
  ((lookupo-clause lookupo == =/=))
  ()
  (conde
    ((fresh (y v rest)
       (== `((,y . ,v) . ,rest) env) (== y x)
       (== v t)))
    ((fresh (y v rest)
       (== `((,y . ,v) . ,rest) env) (=/= y x)
       (lookupo x rest t)))))

(define (mk-clause a b)
  (fresh (x y)
    (conde
      ((== a `(== ,x ,y))
       (== x y)
       (== b '()))
      ((== a `(=/= ,x ,y))
       (=/= x y)
       (== b '()))
      ((== a `(symbolo ,x))
       (symbolo x)
       (== b '())))))

(define (lc-clause a b)
  (conde
    ((eval-expo-clause a b))
    ((not-in-envo-clause a b))
    ((lookupo-clause a b))
    ((l==-clause a b))
    ((mk-clause a b))))

(define (lc-pclause a b)
  (conde
    ((eval-expo-clause a b))
    ((not-in-envo-clause a b))
    ((lookupo-clause a b))))
