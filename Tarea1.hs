-- =====================================================================
--  CI-3661 — Tarea 1 (Haskell) — Septiembre–Diciembre 2026
--
--  Nombre:
--  Carnet:
--
--  Declaración de uso de herramientas de IA (obligatoria, ver enunciado):
--
-- =====================================================================
--  No cambies el nombre del módulo ni la lista de exportación, ni las
--  firmas de las funciones. Puedes agregar todas las funciones auxiliares
--  que quieras. El único import permitido es Data.Char.
-- =====================================================================
module Tarea1
  ( esPalindromo
  , mayorYMenor
  , leerHora
  , duracion
  , promedioSobreUmbral
  , movimientosCaballo
  , enDosSaltos
  , miMap
  , miFilter
  , miFoldl
  ) where

import Data.Char (isAlphaNum, isDigit, toLower, digitToInt)

-- =====================================================================
-- Parte A: recursión explícita.
-- Prohibido: map, filter, foldr, foldl, listas por comprensión, reverse,
-- maximum, minimum, all, any y cualquier otra función de orden superior.
-- =====================================================================

-- A1
-- Determina si una cadena es palíndromo, considerando únicamente caracteres
-- alfanuméricos y sin distinguir entre mayúsculas y minúsculas.
esPalindromo :: String -> Bool
esPalindromo s =
  -- 'let ... in' define una expresión local: primero limpiamos la cadena
  -- y luego comprobamos si es idéntica a su versión invertida.
  let limpia = limpiar s
  in limpia == invertir limpia

-- Filtra los caracteres alfanuméricos de una cadena y los convierte a minúsculas.
limpiar :: String -> String
-- Caso base: una cadena vacía no tiene caracteres que procesar.
limpiar [] = []
-- Caso recursivo: se separa la cabeza 'c' y la cola 'cs' mediante (c:cs).
limpiar (c:cs)
  -- Las guardas (| condición) se evalúan en orden:
  -- Si 'c' es letra o dígito, se convierte a minúscula y se une (:) con la llamada recursiva.
  | isAlphaNum c = toLower c : limpiar cs
  -- Si no es alfanumérico (espacios, signos), se descarta y se continúa con 'cs'.
  | otherwise    = limpiar cs

-- Invierte el orden de los elementos de una lista de caracteres.
-- Inicializa la función auxiliar pasando una lista vacía como acumulador inicial.
invertir :: String -> String
invertir xs = invertirAux xs []

-- Acumula los elementos de la lista en orden inverso mediante recursión de cola.
invertirAux :: String -> String -> String
-- Caso base: al terminar la lista original, el acumulador contiene la cadena invertida.
invertirAux [] acc = acc
-- Caso inductivo: coloca la cabeza actual 'c' al frente del acumulador (c:acc).
invertirAux (c:cs) acc = invertirAux cs (c:acc)

-- A2
-- La función auxiliar 'auxMayorMenor' recorre la lista mediante una recursión de cola
-- procesando cada elemento exactamente una vez, manteniendo y actualizando de forma
-- simultánea el par con el valor máximo y mínimo encontrados hasta el momento.
--
-- Devuelve el par (máximo, mínimo) de una lista, o Nothing si la lista está vacía.
mayorYMenor :: Ord a => [a] -> Maybe (a, a)
-- Si la lista está vacía, Haskell retorna el constructor 'Nothing'.
mayorYMenor [] = Nothing
-- Si tiene al menos un elemento 'x', se inicializan los dos extremos con 'x'
-- y se envuelve el resultado final en el constructor 'Just'.
mayorYMenor (x:xs) = Just (auxMayorMenor x x xs)

-- Recorre los elementos de la lista actualizando el máximo y mínimo acumulados.
auxMayorMenor :: Ord a => a -> a -> [a] -> (a, a)
-- Caso base: cuando ya no quedan elementos por revisar, devuelve el par (max, min).
auxMayorMenor maxAct minAct [] = (maxAct, minAct)
-- Caso recursivo: se evalúa el elemento actual 'y' frente a los acumuladores:
auxMayorMenor maxAct minAct (y:ys)
  | y > maxAct = auxMayorMenor y minAct ys       -- Si supera al máximo, se actualiza maxAct.
  | y < minAct = auxMayorMenor maxAct y ys       -- Si es menor al mínimo, se actualiza minAct.
  | otherwise  = auxMayorMenor maxAct minAct ys  -- En caso contrario, ambos acumuladores se mantienen.


-- A3
-- Lee una cadena en formato "HH:MM" (24 horas) y devuelve (hora, minutos).
-- Retorna Left con el mensaje de error si el formato o los rangos son incorrectos.
leerHora :: String -> Either String (Int, Int)
-- Desestructuración por patrón: calza exactamente listas de 5 caracteres con ':' en medio.
leerHora [h1, h2, ':', m1, m2]
  -- Verifica que los 4 caracteres restantes sean dígitos ('0'..'9').
  | not (isDigit h1 && isDigit h2 && isDigit m1 && isDigit m2) =
      Left "formato inválido"
  -- Verifica rango de horas (0 a 23).
  | h > 23 =
      Left "hora fuera de rango"
  -- Verifica rango de minutos (0 a 59).
  | m > 59 =
      Left "minutos fuera de rango"
  -- Si todas las validaciones son correctas, retorna el par numérico en 'Right'.
  | otherwise =
      Right (h, m)
  where
    -- 'digitToInt' convierte caracteres como '1' al número entero 1.
    h = digitToInt h1 * 10 + digitToInt h2
    m = digitToInt m1 * 10 + digitToInt m2
-- El comodín '_' atrapa cualquier longitud o estructura que no calce el patrón anterior.
leerHora _ = Left "formato inválido"

-- Calcula la diferencia en minutos entre dos horas en formato "HH:MM".
-- Si la segunda hora es anterior a la primera, se asume que corresponde al día siguiente.
duracion :: String -> String -> Either String Int
duracion s1 s2 =
  -- 'case ... of' analiza el resultado de leerHora: si falla, propaga el error (Left);
  -- si tiene éxito (Right), extrae las horas y minutos para continuar.
  case leerHora s1 of
    Left err1 -> Left err1
    Right (h1, m1) ->
      case leerHora s2 of
        Left err2 -> Left err2
        Right (h2, m2) ->
          let t1 = h1 * 60 + m1
              t2 = h2 * 60 + m2
              diff = t2 - t1
          -- Si 'diff < 0' significa que la hora 2 es anterior a la 1, por lo que
          -- se le suman 1440 minutos (24 horas) para considerar el día siguiente.
          in Right (if diff < 0 then diff + 1440 else diff)


-- =====================================================================
-- Parte B: orden superior.
-- Prohibido: recursión explícita (ninguna función de esta parte, ni sus
-- auxiliares, puede llamarse a sí misma).
-- =====================================================================

-- B1
-- Calcula el promedio de los valores de la lista que son estrictamente mayores
-- al umbral dado. Devuelve Nothing si no hay ningún elemento que cumpla la condición.
promedioSobreUmbral :: Double -> [Double] -> Maybe Double
promedioSobreUmbral umbral xs =
  -- 'foldr' procesa la lista con un acumulador en tupla: (suma acumulada, cantidad de elementos).
  -- La lambda (\x (s, c) -> ...) evalúa cada elemento 'x': si x > umbral, suma y cuenta; si no, deja igual.
  let (suma, cuenta) = foldr (\x (s, c) -> if x > umbral then (s + x, c + 1) else (s, c)) (0.0, 0 :: Int) xs
  in if cuenta == 0
       then Nothing
       -- 'fromIntegral' convierte la cuenta de tipo Int a Double para permitir la división (/):
       else Just (suma / fromIntegral cuenta)

-- B2
movimientosCaballo :: (Int, Int) -> [(Int, Int)]
movimientosCaballo = undefined

enDosSaltos :: (Int, Int) -> Int
enDosSaltos = undefined

-- B3
miMap :: (a -> b) -> [a] -> [b]
miMap = undefined

miFilter :: (a -> Bool) -> [a] -> [a]
miFilter = undefined

miFoldl :: (b -> a -> b) -> b -> [a] -> b
miFoldl = undefined
