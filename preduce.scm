;; Inspired by Program 18.3 of The Art of Prolog
;; A simple partial reduction system

(define (preduce* clause)
  (define (solve* goals residues)
    (conde
      ((== goals '())
       (== residues '()))
      ((fresh (g gs)
         (== (cons g gs) goals)
         (conde
           ((fresh (a b ra rb rba rs)
              (== `(<- ,a ,b) g)
              (== `(<- ,ra ,rb) rba)
              (== (cons rba rs) residues)
              (solve* b rb)
              (solve* (list a) ra)
              (solve* gs rs)))
           ((fresh (r rs)
              (== (cons r rs) residues)
              (should-fold g r)
              (solve* gs rs)))
           ((should-unfold g)
            (fresh (b rb rs)
              (clause g b)
              (appendo rb rs residues)
              (solve* b rb)
              (solve* gs rs))))))))
  solve*)

(define (appendo xs ys zs)
  (conde
    ((== xs '())
     (== ys zs))
    ((fresh (x xr zr)
       (== (cons x xr) xs)
       (== (cons x zr) zs)
       (appendo xr ys zr)))))
