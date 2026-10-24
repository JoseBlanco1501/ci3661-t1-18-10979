# ci3661-t1-1810979
**Estudiante:** Jose Alejandro Blanco  
**Carnet:** 18-10979 

# Problema 7: Evaluación por sustitución
 
**Últimos cuatro dígitos:** $d = [0, 9, 7, 9]$  
$d_1 = 0$, $d_2 = 9$

---

### (a) Reducción de `foldr (-) 0 d` hasta llegar a un número

Definición de `foldr`:
- `(FR1) foldr _ z []     = z`
- `(FR2) foldr f z (x:xs) = f x (foldr f z xs)`

Paso a paso:
```haskell
foldr (-) 0 [0, 9, 7, 9]
= 0 - foldr (-) 0 [9, 7, 9]
= 0 - (9 - foldr (-) 0 [7, 9])
= 0 - (9 - (7 - foldr (-) 0 [9]))
= 0 - (9 - (7 - (9 - foldr (-) 0 [])))
= 0 - (9 - (7 - (9 - 0)))
= 0 - (9 - (7 - 9))
= 0 - (9 - (-2))
= 0 - 11
= -11
```

---

### (b) Reducción de `foldl (-) 0 d` hasta llegar a un número

Definición de `foldl`:
- `(FL1) foldl _ z []     = z`
- `(FL2) foldl f z (x:xs) = foldl f (f z x) xs`

Paso a paso:
```haskell
foldl (-) 0 [0, 9, 7, 9]
= foldl (-) (0 - 0) [9, 7, 9]
= foldl (-) ((0 - 0) - 9) [7, 9]
= foldl (-) (((0 - 0) - 9) - 7) [9]
= foldl (-) ((((0 - 0) - 9) - 7) - 9) []
= ((((0 - 0) - 9) - 7) - 9)
= (((0 - 9) - 7) - 9)
= ((-9 - 7) - 9)
= (-16 - 9)
= -25
```

---

### (c) Reducción de `miFoldl (-) 0 [d1, d2]` paso a paso

Con $d_1 = 0$ y $d_2 = 9$, evaluamos `miFoldl (-) 0 [0, 9]`.

Definición en el código:
```haskell
miFoldl f z xs = foldr (\x k acc -> k (f acc x)) (\acc -> acc) xs z
```

Ecuaciones de `foldr`:
- `(FR1) foldr _ z []     = z`
- `(FR2) foldr g b (x:xs) = g x (foldr g b xs)`

Paso a paso:
```text
miFoldl (-) 0 [0, 9]
= foldr (\x k acc -> k (acc - x)) (\acc -> acc) [0, 9] 0
      [por definición de miFoldl con f = (-), z = 0, xs = [0, 9]]

= ((\x k acc -> k (acc - x)) 0 (foldr (\x k acc -> k (acc - x)) (\acc -> acc) [9])) 0
      [por ecuación (FR2) de foldr con cabeza 0 y cola [9]]

= ((\k acc -> k (acc - 0)) (foldr (\x k acc -> k (acc - x)) (\acc -> acc) [9])) 0
      [por regla de β-reducción con x = 0]

= (\acc -> (foldr (\x k acc -> k (acc - x)) (\acc -> acc) [9]) (acc - 0)) 0
      [por regla de β-reducción sobre k]

= (foldr (\x k acc -> k (acc - x)) (\acc -> acc) [9]) (0 - 0)
      [por regla de β-reducción con acc = 0]

= (foldr (\x k acc -> k (acc - x)) (\acc -> acc) [9]) 0
      [por aritmética: 0 - 0 = 0]

= ((\x k acc -> k (acc - x)) 9 (foldr (\x k acc -> k (acc - x)) (\acc -> acc) [])) 0
      [por ecuación (FR2) de foldr con cabeza 9 y cola []]

= ((\k acc -> k (acc - 9)) (foldr (\x k acc -> k (acc - x)) (\acc -> acc) [])) 0
      [por regla de β-reducción con x = 9]

= (\acc -> (foldr (\x k acc -> k (acc - x)) (\acc -> acc) []) (acc - 9)) 0
      [por regla de β-reducción sobre k]

= (foldr (\x k acc -> k (acc - x)) (\acc -> acc) []) (0 - 9)
      [por regla de β-reducción con acc = 0]

= (foldr (\x k acc -> k (acc - x)) (\acc -> acc) []) (-9)
      [por aritmética: 0 - 9 = -9]

= (\acc -> acc) (-9)
      [por ecuación (FR1) de foldr sobre lista vacía []]

= -9
      [por regla de β-reducción con acc = -9]
```

---

### (d) Justificación y condición de igualdad

Las expresiones (a) y (b) dan valores distintos (-11 frente a -25) debido a la asociatividad: `foldr` asocia la operación hacia la derecha, agrupando los operandos como `(0 - (9 - (7 - (9 - 0))))`, mientras que `foldl` la asocia hacia la izquierda, acumulando como `((((0 - 0) - 9) - 7) - 9)`. Como la resta `(-)` no es un operador asociativo (es decir, en el caso general $a - (b - c) \neq (a - b) - c$), el orden de agrupación altera el resultado del cálculo.

Para garantizar que `foldr op z xs == foldl op z xs` para toda lista finita `xs`, se requiere que el par formado por el operador `op` y el valor base `z` constituya un monoide; esto es, que el operador `op` sea asociativo (`(a `op` b) `op` c == a `op` (b `op` c)`) y que `z` sea su elemento neutro por ambos lados (`z `op` a == a` y `a `op` z == a`).
