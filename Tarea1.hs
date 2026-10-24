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
leerHora :: String -> Either String (Int, Int)
leerHora = undefined

duracion :: String -> String -> Either String Int
duracion = undefined

-- =====================================================================
-- Parte B: orden superior.
-- Prohibido: recursión explícita (ninguna función de esta parte, ni sus
-- auxiliares, puede llamarse a sí misma).
-- =====================================================================

-- B1
promedioSobreUmbral :: Double -> [Double] -> Maybe Double
promedioSobreUmbral = undefined

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
