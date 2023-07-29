(let
  [api vim.api f vim.fn
   time-out vim.o.timeoutlen]

  ; State
  (var key-presses 0)
  (var previous-key nil)
  (var previous-time 0)

  (fn handle [key max-presses substitute]
    (let
      [current-time (* (f.reltimefloat (f.reltime)) 1000)
       elapsed (- current-time previous-time)
       normal
         (fn [key]
           (vim.cmd
             (string.format
               "normal! %s%s"
               vim.v.count1 key)))]
      (if
        ; Don't change the key behaviour if it hasn't been
        ; repeated, or if it timed out. Also track it
        (or (not= key previous-key) (> elapsed time-out))
        (do
          (set key-presses 1)
          (set previous-time current-time)
          (set previous-key key)
          (normal key))
        ; If the key was repeated, but it hasn't timed out
        ; and its limit has not been reached, do the normal
        ; thing and increase the counter
        (< key-presses max-presses)
        (do
          (set key-presses (+ key-presses 1))
          (normal key))
        ; If the key has been used enough times before
        ; timing out, execute the alternative action and
        ; reset the state
        (>= key-presses max-presses)
        (do
          (set key-presses 0)
          (set previous-time 0)
          (set previous-key nil)
          (case (type substitute)
            :function
            (substitute)
            :string
            (let [{: mode} (api.nvim_get_mode)]
              (case (f.maparg substitute mode false true)
                {: callback}
                (callback)
                {: rhs}
                (let [(success result) (pcall api.nvim_eval rhs)]
                  (when (not success)
                    (print (string.format "Error: %s" result)))))))))))

  (fn [maps mode max-presses]
    (each [key action (pairs maps)]
      (vim.keymap.set mode key
        (fn [] (handle key max-presses action))
        {:noremap true}))))
