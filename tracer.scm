(define (tracer* clause)
  (define (solve* goals trace-in trace-out)
    (conde
      ((== goals '())
       (== trace-in trace-out))
      ((fresh (first-goal other-goals first-body trace-out-body)
         (== (cons first-goal other-goals) goals)
         (clause first-goal first-body)
         (solve* first-body (cons first-goal trace-in) trace-out-body)
         (solve* other-goals trace-out-body trace-out)))))
  (lambda (goals trace)
    (fresh ()
      (solve* goals '()  trace))))

(define tracer (one-goal tracer*))
