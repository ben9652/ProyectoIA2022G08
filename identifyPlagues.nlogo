globals
[
  num-pm     ; número total de perforadores menores
  num-gc     ; número total de gusanos cuarteadores
  num-gp     ; número total de gusanos perforadores
  num-all    ; número total de insectos generados
  center-pm  ; centro de coordenadas de cada perforador menor
  center-gc  ; centro de coordenadas de cada gusano cuarteador
  center-gp  ; centro de coordenadas de cada gusano perforador
  center-all ; centro de coordenadas de cada insecto generado

  coord-pm   ; coordenada de prueba de perforador menor
  coord-gc   ; coordenada de prueba de gusano cuarteador
  coord-gp   ; coordenada de prueba de gusano perforador

  perforadores-menores-encontrados
  gusanos-cuarteadores-encontrados
  gusanos-perforadores-encontrados

  direccion-giro

  no-hay-pm-nuevo ; variable booleana usada para la generación de perforadores menores
  no-hay-gc-nuevo ; variable booleana usada para la generación de gusanos cuarteadores
  no-hay-gp-nuevo ; variable booleana usada para la generación de gusanos perforadores
]

turtles-own
[
  tiempo-desde-ultimo-encuentro
  buscando ; indica si el agente está buscando insectos
  guiado ; indica si el agente ya se guió con el ángulo adecuado para bordear el insecto
  posicionado ; indica si el agente está por fin en posición para identificar al insecto

  partes-pintadas-encontradas
  partes-pintadas

  choque-frontal
  choca-en-esquina-vacio-izquierda
  choca-en-esquina-vacio-derecha
  choque-hueco-angosto
  se-acerca-a-hueco
  choca-oblicuamente-derecha-nada
  choca-oblicuamente-izquierda-nada
  choque-oblicuo-rodeado

  sentido-establecido
  sentido-horario

  e-rojo       ; indica si hay un insecto enfrente
  d-rojo        ; indica si hay un insecto a su derecha
  i-rojo      ; indica si hay un insecto a su izquierda
  e-d-rojo            ; indica si hay un insecto enfrente tirando para su derecha
  e-i-rojo            ; indica si hay un insecto enfrente tirando para la izquierda
  a-d-rojo            ; indica si hay un insecto atrás tirando para la derecha
  a-i-rojo            ; indica si hay un insecto atrás tirando para la izquierda

  e-amarillo   ; indica si hay un cuadrado de insecto marcado enfrente
  d-amarillo    ; indica si hay un cuadrado de insecto marcado a su derecha
  i-amarillo  ; indica si hay un cuadrado de insecto marcado a su izquierda
  e-d-amarillo        ; indica si hay un cuadrado de insecto marcado enfrente para su derecha
  e-i-amarillo        ; indica si hay un cuadrado de insecto marcado enfrente para su izquierda
  a-d-amarillo        ; indica si hay un cuadrado de insecto marcado atrás para la derecha
  a-i-amarillo        ; indica si hay un cuadrado de insecto marcado atrás para la izquierda

  e-vacio      ; indica si hay un cuadrado vacio enfrente del agente
  d-vacio       ; indica si hay un cuadrado vacio a la derecha del agente
  i-vacio     ; indica si hay un cuadrado vacio a la izquierda del agente
  e-d-vacio           ; indica si hay un cuadrado vacio enfrente del agente para su derecha
  e-i-vacio           ; indica si hay un cuadrado vacio enfrente del agente para su izquierda
  a-d-vacio           ; indica si hay un cuadrado vacio atrás del agente a la derecha
  a-i-vacio           ; indica si hay un cuadrado vacio atrás del agente a la izquierda
]

to setup
  clear-all

  set center-pm []
  set center-gc []
  set center-gp []
  set center-all []

  set num-pm random 5
  set num-gc random 5
  set num-gp random 5
  set num-all 0

  let i 0
  while [i < num-pm]
  [
    ; La grilla es de 200x200. Pero para evitar el corte de perforadores menores, ubicaré su
    ; centro en un cuadrado centrado de (300-20)x(200-20) = 280x180, ya que 20 es el largo
    ; máximo de un perforador menor.
    set coord-pm list ((random 281) - 140) ((random 181) - 90)
    if num-all != 0
    [
      set no-hay-pm-nuevo true
      while [no-hay-pm-nuevo]
      [
        busqueda-centro-adecuado-pm
      ]
    ]
    set center-pm lput coord-pm center-pm   ; Agrego la coordenada del perforador menor
    set center-all lput coord-pm center-all

    set num-all num-all + 1

    crear-perforador-menor
    set i i + 1
  ]

  set i 0
  while [i < num-gc]
  [
    ; La grilla es de 200x200. Pero para evitar el corte de gusanos cuarteadores, ubicaré su
    ; centro en un cuadrado centrado de (300-40)x(200-40) = 260x160, ya que 40 es el largo
    ; máximo de un gusano cuarteador.
    set coord-gc list ((random 261) - 130) ((random 161) - 80)
    if num-all != 0
    [
      set no-hay-gc-nuevo true
      while [no-hay-gc-nuevo]
      [
        busqueda-centro-adecuado-gc
      ]
    ]
    set center-gc lput coord-gc center-gc   ; Agrego la coordenada del gusano cuarteador
    set center-all lput coord-gc center-all

    set num-all num-all + 1

    crear-gusano-cuarteador
    set i i + 1
  ]

  set i 0
  while [i < num-gp]
  [
    ; La grilla es de 200x200. Pero para evitar el corte de gusanos perforadores, ubicaré su
    ; centro en un cuadrado centrado de (300-39)x(200-39) = 261x161, ya que 39 es el largo
    ; máximo de un gusano perforador
    set coord-gp list ((random 262) - 130) ((random 162) - 80)
    if num-all != 0
    [
      set no-hay-gp-nuevo true
      while [no-hay-gp-nuevo]
      [
        busqueda-centro-adecuado-gp         ; Hace que no se superpongan insectos
      ]
    ]
    set center-gp lput coord-gp center-gp   ; Agrego la coordenada del gusano perforador
    set center-all lput coord-gp center-all

    set num-all num-all + 1

    crear-gusano-perforador
    set i i + 1
  ]

  agregar-tortuga

  reset-ticks
end

to agregar-tortuga
  let x-cor-turtle 0
  let y-cor-turtle 0
  let esRoja true
  while [esRoja = true]
  [
    set x-cor-turtle random-xcor
    set y-cor-turtle random-ycor

    ask (patch x-cor-turtle y-cor-turtle)
    [
      if pcolor != red [set esRoja false]
    ]
  ]

  create-turtles 1
  [
    setxy x-cor-turtle y-cor-turtle
    set color yellow

    set buscando true
    set guiado false
    set posicionado false

    set partes-pintadas-encontradas 0
    set partes-pintadas 0

    set perforadores-menores-encontrados 0
    set gusanos-cuarteadores-encontrados 0
    set gusanos-perforadores-encontrados 0

    set choque-frontal false
    set choca-en-esquina-vacio-izquierda false
    set choca-en-esquina-vacio-derecha false
    set choca-oblicuamente-derecha-nada false
    set choca-oblicuamente-izquierda-nada false
    set choque-hueco-angosto false
    set se-acerca-a-hueco false
    set choca-oblicuamente-derecha-nada false
    set choca-oblicuamente-izquierda-nada false
    set choque-oblicuo-rodeado false

    set sentido-establecido false
    set sentido-horario false

    set e-rojo false
    set i-rojo false
    set e-d-rojo false
    set e-i-rojo false
    set a-d-rojo false
    set a-i-rojo false

    set e-amarillo false
    set d-amarillo false
    set i-amarillo false
    set e-d-amarillo false
    set e-i-amarillo false
    set a-d-amarillo false
    set a-i-amarillo false

    set e-vacio false
    set d-vacio false
    set i-vacio false
    set e-d-vacio false
    set e-i-vacio false
    set a-d-vacio false
    set a-i-vacio false
  ]
end

to busqueda-centro-adecuado-pm
  foreach center-all
  [
    [insecto] -> ; Se recoge el centro de coordenadas de cada elemento

    ; Aquí calculo la diferencia de las coordenadas x del centro del
    ; insecto con el insecto nuevo que se va a insertar
    let x1-x0 (item 0 insecto - item 0 coord-pm)

    ; Aquí calculo la diferencia de las coordenadas y del centro del
    ; insecto con el insecto nuevo que se va a insertar
    let y1-y0 (item 1 insecto - item 1 coord-pm)

    ; Si el centro del insecto nuevo que se va a insertar tiene una
    ; distancia menor o igual a 40 tanto en las x como en las y, se
    ; buscará otro centro de coordenada en el que insertarlo.
    ; Si resulta ser falsa la proposición, se considera un centro de
    ; coordenadas correcto para la inserción del insecto.
    if abs y1-y0 < 41 AND abs x1-x0 < 41
    [
      set coord-pm list ((random 281) - 140) ((random 181) - 90)
      stop
    ]
  ]

  set no-hay-pm-nuevo false
end

to busqueda-centro-adecuado-gc
  foreach center-all
  [
    [insecto] -> ; Se recoge el centro de coordenadas de cada elemento

    ; Aquí calculo la diferencia de las coordenadas x del centro del
    ; insecto con el insecto nuevo que se va a insertar
    let x1-x0 (item 0 insecto - item 0 coord-gc)

    ; Aquí calculo la diferencia de las coordenadas y del centro del
    ; insecto con el insecto nuevo que se va a insertar
    let y1-y0 (item 1 insecto - item 1 coord-gc)

    ; Si el centro del insecto nuevo que se va a insertar tiene una
    ; distancia menor o igual a 40 tanto en las x como en las y, se
    ; buscará otro centro de coordenada en el que insertarlo.
    ; Si resulta ser falsa la proposición, se considera un centro de
    ; coordenadas correcto para la inserción del insecto.
    if abs y1-y0 < 41 AND abs x1-x0 < 41
    [
      set coord-gc list ((random 261) - 130) ((random 161) - 80)
      stop
    ]
  ]

  set no-hay-gc-nuevo false
end

to busqueda-centro-adecuado-gp
  foreach center-all
  [
    [insecto] -> ; Se recoge el centro de coordenadas de cada elemento

    ; Aquí calculo la diferencia de las coordenadas x del centro del
    ; insecto con el insecto nuevo que se va a insertar
    let x1-x0 (item 0 insecto - item 0 coord-gp)

    ; Aquí calculo la diferencia de las coordenadas y del centro del
    ; insecto con el insecto nuevo que se va a insertar
    let y1-y0 (item 1 insecto - item 1 coord-gp)

    ; Si el centro del insecto nuevo que se va a insertar tiene una
    ; distancia menor o igual a 40 tanto en las x como en las y, se
    ; buscará otro centro de coordenada en el que insertarlo.
    ; Si resulta ser falsa la proposición, se considera un centro de
    ; coordenadas correcto para la inserción del insecto.
    if abs y1-y0 < 41 AND abs x1-x0 < 41
    [
      set coord-gp list ((random 262) - 130) ((random 162) - 80)
      stop
    ]
  ]

  set no-hay-gp-nuevo false
end

to crear-perforador-menor
  let orientacion 0
  set orientacion random 2
  ifelse orientacion = 1
  [
    ask patches with
    [pxcor = item 0 coord-pm - 3 AND (pycor >= item 1 coord-pm - 3 AND pycor <= item 1 coord-pm - 2)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-pm - 3 AND (pycor >= item 1 coord-pm + 1 AND pycor <= item 1 coord-pm + 2)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-pm - 3 AND (pycor >= item 1 coord-pm + 5 AND pycor <= item 1 coord-pm + 6)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-pm - 2 AND (pycor >= item 1 coord-pm - 3 AND pycor <= item 1 coord-pm + 3)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-pm - 2 AND (pycor >= item 1 coord-pm + 5 AND pycor <= item 1 coord-pm + 6)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-pm - 1 AND (pycor >= item 1 coord-pm - 9 AND pycor <= item 1 coord-pm + 8)]
    [set pcolor red]

    ask patches with
    [(pxcor >= item 0 coord-pm AND pxcor <= item 0 coord-pm + 1) AND (pycor >= item 1 coord-pm - 7 AND pycor <= item 1 coord-pm + 7)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-pm + 2 AND (pycor >= item 1 coord-pm - 9 AND pycor <= item 1 coord-pm + 8)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-pm + 3 AND (pycor >= item 1 coord-pm - 3 AND pycor <= item 1 coord-pm + 3)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-pm + 3 AND (pycor >= item 1 coord-pm + 5 AND pycor <= item 1 coord-pm + 6)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-pm + 4 AND (pycor >= item 1 coord-pm - 3 AND pycor <= item 1 coord-pm - 2)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-pm + 4 AND (pycor >= item 1 coord-pm + 1 AND pycor <= item 1 coord-pm + 2)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-pm + 4 AND (pycor >= item 1 coord-pm + 5 AND pycor <= item 1 coord-pm + 6)]
    [set pcolor red]
  ]
  [
    ask patches with
    [pycor = item 1 coord-pm + 3 AND (pxcor >= item 1 coord-pm - 3 AND pxcor <= item 1 coord-pm - 2)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-pm + 3 AND (pxcor >= item 1 coord-pm + 1 AND pxcor <= item 1 coord-pm + 2)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-pm + 3 AND (pxcor >= item 1 coord-pm + 5 AND pxcor <= item 1 coord-pm + 6)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-pm + 2 AND (pxcor >= item 1 coord-pm - 3 AND pxcor <= item 1 coord-pm + 3)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-pm + 2 AND (pxcor >= item 1 coord-pm + 5 AND pxcor <= item 1 coord-pm + 6)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-pm + 1 AND (pxcor >= item 1 coord-pm - 9 AND pxcor <= item 1 coord-pm + 8)]
    [set pcolor red]

    ask patches with
    [(pycor >= item 1 coord-pm - 1 AND pycor <= item 1 coord-pm) AND (pxcor >= item 1 coord-pm - 7 AND pxcor <= item 1 coord-pm + 7)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-pm - 2 AND (pxcor >= item 1 coord-pm - 9 AND pxcor <= item 1 coord-pm + 8)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-pm - 3 AND (pxcor >= item 1 coord-pm - 3 AND pxcor <= item 1 coord-pm + 3)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-pm - 3 AND (pxcor >= item 1 coord-pm + 5 AND pxcor <= item 1 coord-pm + 6)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-pm - 4 AND (pxcor >= item 1 coord-pm - 3 AND pxcor <= item 1 coord-pm - 2)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-pm - 4 AND (pxcor >= item 1 coord-pm + 1 AND pxcor <= item 1 coord-pm + 2)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-pm - 4 AND (pxcor >= item 1 coord-pm + 5 AND pxcor <= item 1 coord-pm + 6)]
    [set pcolor red]
  ]
end

to crear-gusano-cuarteador
  let orientacion 0
  set orientacion random 2
  ifelse orientacion = 1
  [
    ask patches with
    [pxcor = item 0 coord-gc - 4 AND pycor = item 1 coord-gc - 14]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gc - 4 AND (pycor >= item 1 coord-gc - 11 AND pycor <= item 1 coord-gc - 8)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gc - 4 AND (pycor >= item 1 coord-gc + 4 AND pycor <= item 1 coord-gc + 7)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gc - 4 AND (pycor >= item 1 coord-gc + 11 AND pycor <= item 1 coord-gc + 14)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-gc - 3 AND pycor = item 1 coord-gc - 14]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gc - 3 AND (pycor >= item 1 coord-gc - 11 AND pycor <= item 1 coord-gc - 8)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gc - 3 AND (pycor >= item 1 coord-gc + 4 AND pycor <= item 1 coord-gc + 7)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gc - 3 AND (pycor >= item 1 coord-gc + 11 AND pycor <= item 1 coord-gc + 14)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-gc - 2 AND (pycor >= item 1 coord-gc - 21 AND pycor <= item 1 coord-gc + 18)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-gc - 1 AND (pycor >= item 1 coord-gc - 19 AND pycor <= item 1 coord-gc + 16)]
    [set pcolor red]

    ask patches with
    [(pxcor >= item 0 coord-gc AND pxcor <= item 0 coord-gc + 1) AND (pycor >= item 1 coord-gc - 19 AND pycor <= item 1 coord-gc + 18)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-gc + 2 AND (pycor >= item 1 coord-gc - 19 AND pycor <= item 1 coord-gc + 16)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-gc + 3 AND (pycor >= item 1 coord-gc - 21 AND pycor <= item 1 coord-gc + 18)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-gc + 4 AND pycor = item 1 coord-gc - 14]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gc + 4 AND (pycor >= item 1 coord-gc - 11 AND pycor <= item 1 coord-gc - 8)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gc + 4 AND (pycor >= item 1 coord-gc + 4 AND pycor <= item 1 coord-gc + 7)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gc + 4 AND (pycor >= item 1 coord-gc + 11 AND pycor <= item 1 coord-gc + 14)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-gc + 5 AND pycor = item 1 coord-gc - 14]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gc + 5 AND (pycor >= item 1 coord-gc - 11 AND pycor <= item 1 coord-gc - 8)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gc + 5 AND (pycor >= item 1 coord-gc + 4 AND pycor <= item 1 coord-gc + 7)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gc + 5 AND (pycor >= item 1 coord-gc + 11 AND pycor <= item 1 coord-gc + 14)]
    [set pcolor red]
  ]
  [
    ask patches with
    [pycor = item 1 coord-gc + 4 AND pxcor = item 0 coord-gc - 14]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gc + 4 AND (pxcor >= item 0 coord-gc - 11 AND pxcor <= item 0 coord-gc - 8)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gc + 4 AND (pxcor >= item 0 coord-gc + 4 AND pxcor <= item 0 coord-gc + 7)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gc + 4 AND (pxcor >= item 0 coord-gc + 11 AND pxcor <= item 0 coord-gc + 14)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-gc + 3 AND pxcor = item 0 coord-gc - 14]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gc + 3 AND (pxcor >= item 0 coord-gc - 11 AND pxcor <= item 0 coord-gc - 8)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gc + 3 AND (pxcor >= item 0 coord-gc + 4 AND pxcor <= item 0 coord-gc + 7)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gc + 3 AND (pxcor >= item 0 coord-gc + 11 AND pxcor <= item 0 coord-gc + 14)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-gc + 2 AND (pxcor >= item 0 coord-gc - 21 AND pxcor <= item 0 coord-gc + 18)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-gc + 1 AND (pxcor >= item 0 coord-gc - 19 AND pxcor <= item 0 coord-gc + 16)]
    [set pcolor red]

    ask patches with
    [(pycor >= item 1 coord-gc - 1 AND pycor <= item 1 coord-gc) AND (pxcor >= item 0 coord-gc - 19 AND pxcor <= item 0 coord-gc + 18)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-gc - 2 AND (pxcor >= item 0 coord-gc - 19 AND pxcor <= item 0 coord-gc + 16)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-gc - 3 AND (pxcor >= item 0 coord-gc - 21 AND pxcor <= item 0 coord-gc + 18)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-gc - 4 AND pxcor = item 0 coord-gc - 14]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gc - 4 AND (pxcor >= item 0 coord-gc - 11 AND pxcor <= item 0 coord-gc - 8)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gc - 4 AND (pxcor >= item 0 coord-gc + 4 AND pxcor <= item 0 coord-gc + 7)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gc - 4 AND (pxcor >= item 0 coord-gc + 11 AND pxcor <= item 0 coord-gc + 14)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-gc - 5 AND pxcor = item 0 coord-gc - 14]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gc - 5 AND (pxcor >= item 0 coord-gc - 11 AND pxcor <= item 0 coord-gc - 8)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gc - 5 AND (pxcor >= item 0 coord-gc + 4 AND pxcor <= item 0 coord-gc + 7)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gc - 5 AND (pxcor >= item 0 coord-gc + 11 AND pxcor <= item 0 coord-gc + 14)]
    [set pcolor red]
  ]
end

to crear-gusano-perforador
  let orientacion 0
  set orientacion random 2
  ifelse orientacion = 1
  [
    ask patches with
    [pxcor = item 0 coord-gp - 5 AND (pycor >= item 1 coord-gp - 11 AND pycor <= item 1 coord-gp - 9)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp - 5 AND (pycor >= item 1 coord-gp - 7 AND pycor <= item 1 coord-gp - 4)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp - 5 AND (pycor >= item 1 coord-gp - 1 AND pycor <= item 1 coord-gp + 1)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp - 5 AND (pycor >= item 1 coord-gp + 4 AND pycor <= item 1 coord-gp + 7)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp - 5 AND (pycor >= item 1 coord-gp + 9 AND pycor <= item 1 coord-gp + 12)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp - 5 AND (pycor >= item 1 coord-gp + 14 AND pycor <= item 1 coord-gp + 16)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-gp - 4 AND pycor = item 1 coord-gp - 17]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp - 4 AND (pycor >= item 1 coord-gp - 15 AND pycor <= item 1 coord-gp - 14)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp - 4 AND (pycor >= item 1 coord-gp - 12 AND pycor <= item 1 coord-gp + 17)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp - 4 AND pycor = item 1 coord-gp + 19]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-gp - 3 AND (pycor >= item 1 coord-gp - 18 AND pycor <= item 1 coord-gp + 19)]
    [set pcolor red]

    ask patches with
    [(pxcor >= item 0 coord-gp - 2 AND pxcor <= item 0 coord-gp + 1) AND (pycor >= item 1 coord-gp - 19 AND pycor <= item 1 coord-gp + 19)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-gp + 2 AND (pycor >= item 1 coord-gp - 18 AND pycor <= item 1 coord-gp + 19)]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-gp + 3 AND pycor = item 1 coord-gp - 17]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp + 3 AND (pycor >= item 1 coord-gp - 15 AND pycor <= item 1 coord-gp - 14)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp + 3 AND (pycor >= item 1 coord-gp - 12 AND pycor <= item 1 coord-gp + 17)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp + 3 AND pycor = item 1 coord-gp + 19]
    [set pcolor red]

    ask patches with
    [pxcor = item 0 coord-gp + 4 AND (pycor >= item 1 coord-gp - 11 AND pycor <= item 1 coord-gp - 9)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp + 4 AND (pycor >= item 1 coord-gp - 7 AND pycor <= item 1 coord-gp - 4)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp + 4 AND (pycor >= item 1 coord-gp - 1 AND pycor <= item 1 coord-gp + 1)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp + 4 AND (pycor >= item 1 coord-gp + 4 AND pycor <= item 1 coord-gp + 7)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp + 4 AND (pycor >= item 1 coord-gp + 9 AND pycor <= item 1 coord-gp + 12)]
    [set pcolor red]
    ask patches with
    [pxcor = item 0 coord-gp + 4 AND (pycor >= item 1 coord-gp + 14 AND pycor <= item 1 coord-gp + 16)]
    [set pcolor red]
  ]
  [
    ask patches with
    [pycor = item 1 coord-gp + 5 AND (pxcor >= item 0 coord-gp - 11 AND pxcor <= item 0 coord-gp - 9)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp + 5 AND (pxcor >= item 0 coord-gp - 7 AND pxcor <= item 0 coord-gp - 4)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp + 5 AND (pxcor >= item 0 coord-gp - 1 AND pxcor <= item 0 coord-gp + 1)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp + 5 AND (pxcor >= item 0 coord-gp + 4 AND pxcor <= item 0 coord-gp + 7)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp + 5 AND (pxcor >= item 0 coord-gp + 9 AND pxcor <= item 0 coord-gp + 12)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp + 5 AND (pxcor >= item 0 coord-gp + 14 AND pxcor <= item 0 coord-gp + 16)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-gp + 4 AND pxcor = item 0 coord-gp - 17]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp + 4 AND (pxcor >= item 0 coord-gp - 15 AND pxcor <= item 0 coord-gp - 14)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp + 4 AND (pxcor >= item 0 coord-gp - 12 AND pxcor <= item 0 coord-gp + 17)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp + 4 AND pxcor = item 0 coord-gp + 19]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-gp + 3 AND (pxcor >= item 0 coord-gp - 18 AND pxcor <= item 0 coord-gp + 19)]
    [set pcolor red]

    ask patches with
    [(pycor >= item 1 coord-gp - 1 AND pycor <= item 1 coord-gp + 2) AND (pxcor >= item 0 coord-gp - 19 AND pxcor <= item 0 coord-gp + 19)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-gp - 2 AND (pxcor >= item 0 coord-gp - 18 AND pxcor <= item 0 coord-gp + 19)]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-gp - 3 AND pxcor = item 0 coord-gp - 17]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp - 3 AND (pxcor >= item 0 coord-gp - 15 AND pxcor <= item 0 coord-gp - 14)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp - 3 AND (pxcor >= item 0 coord-gp - 12 AND pxcor <= item 0 coord-gp + 17)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp - 3 AND pxcor = item 0 coord-gp + 19]
    [set pcolor red]

    ask patches with
    [pycor = item 1 coord-gp - 4 AND (pxcor >= item 0 coord-gp - 11 AND pxcor <= item 0 coord-gp - 9)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp - 4 AND (pxcor >= item 0 coord-gp - 7 AND pxcor <= item 0 coord-gp - 4)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp - 4 AND (pxcor >= item 0 coord-gp - 1 AND pxcor <= item 0 coord-gp + 1)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp - 4 AND (pxcor >= item 0 coord-gp + 4 AND pxcor <= item 0 coord-gp + 7)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp - 4 AND (pxcor >= item 0 coord-gp + 9 AND pxcor <= item 0 coord-gp + 12)]
    [set pcolor red]
    ask patches with
    [pycor = item 1 coord-gp - 4 AND (pxcor >= item 0 coord-gp + 14 AND pxcor <= item 0 coord-gp + 16)]
    [set pcolor red]
  ]
end

to go
  actualizar-sensores
  ask turtles [search]
  tick
end

to actualizar-sensores
  ask turtles [
    ifelse [pcolor] of patch-ahead 1 = red [set e-rojo true] [set e-rojo false]
    ifelse [pcolor] of patch-right-and-ahead 90 1 = red [set d-rojo true] [set d-rojo false]
    ifelse [pcolor] of patch-left-and-ahead 90 1 = red [set i-rojo true] [set i-rojo false]
    ifelse [pcolor] of patch-right-and-ahead 45 1 = red [set e-d-rojo true] [set e-d-rojo false]
    ifelse [pcolor] of patch-left-and-ahead 45 1 = red [set e-i-rojo true] [set e-i-rojo false]
    ifelse [pcolor] of patch-right-and-ahead 135 1 = red [set a-d-rojo true] [set a-d-rojo false]
    ifelse [pcolor] of patch-left-and-ahead 135 1 = red [set a-i-rojo true] [set a-i-rojo false]

    ifelse [pcolor] of patch-ahead 1 = yellow [set e-amarillo true] [set e-amarillo false]
    ifelse [pcolor] of patch-right-and-ahead 90 1 = yellow [set d-amarillo true] [set d-amarillo false]
    ifelse [pcolor] of patch-left-and-ahead 90 1 = yellow [set i-amarillo true] [set i-amarillo false]
    ifelse [pcolor] of patch-right-and-ahead 45 1 = yellow [set e-d-amarillo true] [set e-d-amarillo false]
    ifelse [pcolor] of patch-left-and-ahead 45 1 = yellow [set e-i-amarillo true] [set e-i-amarillo false]
    ifelse [pcolor] of patch-right-and-ahead 135 1 = yellow [set a-d-amarillo true] [set a-d-amarillo false]
    ifelse [pcolor] of patch-left-and-ahead 135 1 = yellow [set a-i-amarillo true] [set a-i-amarillo false]

    ifelse [pcolor] of patch-ahead 1 = black [set e-vacio true] [set e-vacio false]
    ifelse [pcolor] of patch-right-and-ahead 90 1 = black [set d-vacio true] [set d-vacio false]
    ifelse [pcolor] of patch-left-and-ahead 90 1 = black [set i-vacio true] [set i-vacio false]
    ifelse [pcolor] of patch-right-and-ahead 45 1 = black [set e-d-vacio true] [set e-d-vacio false]
    ifelse [pcolor] of patch-left-and-ahead 45 1 = black [set e-i-vacio true] [set e-i-vacio false]
    ifelse [pcolor] of patch-right-and-ahead 135 1 = black [set a-d-vacio true] [set a-d-vacio false]
    ifelse [pcolor] of patch-left-and-ahead 135 1 = black [set a-i-vacio true] [set a-i-vacio false]
  ]
end

to search
  ifelse buscando = true
  [
    ifelse tiempo-desde-ultimo-encuentro <= 20
    [right (random 181) - 20]
    [right (random 21) - 10]

    ifelse (e-rojo OR e-d-rojo OR e-i-rojo) AND NOT e-amarillo AND NOT e-d-amarillo AND NOT e-i-amarillo AND NOT i-amarillo AND NOT d-amarillo
    [
      set buscando false
    ]
    [
      if (e-amarillo OR e-d-amarillo OR e-i-amarillo) AND NOT i-amarillo AND NOT d-amarillo [right 180]

      forward 1
      set tiempo-desde-ultimo-encuentro tiempo-desde-ultimo-encuentro + 1
    ]
  ]
  [
    if NOT guiado
    [guiar]

    ; Ahora se ubicará al agente en una posición discreta
    if NOT posicionado
    [posicionar]
  ]
end

to identificar
  ask turtles [
    pintar-automatico
    avanzar-automatico
  ]
  actualizar-sensores
  tick
end

to pintar-automatico
  if NOT buscando
    [
      if i-rojo
      [
        ask patch-left-and-ahead 90 1 [set pcolor yellow]
        set partes-pintadas partes-pintadas + 1
        set partes-pintadas-encontradas 0
      ]

      if d-rojo
      [
        ask patch-right-and-ahead 90 1 [set pcolor yellow]
        set partes-pintadas partes-pintadas + 1
        set partes-pintadas-encontradas 0
      ]

      if e-rojo
      [
        ask patch-ahead 1 [set pcolor yellow]
        set partes-pintadas partes-pintadas + 1
        set partes-pintadas-encontradas 0
      ]

      if i-amarillo
      [
        ifelse partes-pintadas-encontradas <= 10
        [
          set partes-pintadas-encontradas partes-pintadas-encontradas + 1
        ]
        [
          if partes-pintadas >= 46 AND partes-pintadas <= 52
          [set perforadores-menores-encontrados perforadores-menores-encontrados + 1]
          if partes-pintadas >= 104 AND partes-pintadas <= 110
          [set gusanos-cuarteadores-encontrados gusanos-cuarteadores-encontrados + 1]
          if partes-pintadas >= 86 AND partes-pintadas <= 92
          [set gusanos-perforadores-encontrados gusanos-perforadores-encontrados + 1]
          right 90
          set buscando true
          set partes-pintadas-encontradas 0
          set partes-pintadas 0
          set guiado false
          set posicionado false
        ]
      ]

      if d-amarillo
      [
        ifelse partes-pintadas-encontradas <= 10
        [
          set partes-pintadas-encontradas partes-pintadas-encontradas + 1
        ]
        [
          if partes-pintadas = 46 [set perforadores-menores-encontrados perforadores-menores-encontrados + 1]
          if partes-pintadas = 104 [set gusanos-cuarteadores-encontrados gusanos-cuarteadores-encontrados + 1]
          if partes-pintadas = 86 [set gusanos-perforadores-encontrados gusanos-perforadores-encontrados + 1]
          left 90
          set buscando true
          set partes-pintadas-encontradas 0
          set partes-pintadas 0
          set guiado false
          set posicionado false
        ]
      ]
    ]
end

to avanzar-automatico
  let d-rojo-2 false
  let i-rojo-2 false

  if [pcolor] of patch-right-and-ahead 90 2 = red [set d-rojo-2 true]
  if [pcolor] of patch-left-and-ahead 90 2 = red [set i-rojo-2 true]

  if NOT buscando
    [
      ; Si se recorre en sentido anti-horario

      ; Esto por si el agente se llega a parar en una ubicación desafortunada
      ; en la que no tiene al lado una parte del cuerpo del insecto
      if NOT sentido-horario AND (e-i-rojo AND i-vacio OR a-i-rojo AND i-vacio) AND partes-pintadas = 0 [forward 1]
      if NOT sentido-horario AND i-amarillo AND d-vacio AND e-vacio [forward 1]
      if NOT sentido-horario AND a-i-amarillo AND i-vacio
      [
        left 90
        forward 1
      ]
      if NOT sentido-horario AND e-amarillo AND d-vacio AND (NOT a-i-amarillo OR NOT i-vacio OR NOT i-rojo-2)
      [
        right 90
        forward 1
      ]
      if NOT sentido-horario AND e-amarillo AND d-rojo
      [
        left 180
        forward 1
        left 90
        forward 1
      ]
      if NOT sentido-horario AND e-amarillo AND d-amarillo AND i-amarillo
      [
        left 180
      ]
      if NOT sentido-horario AND d-amarillo AND i-amarillo AND e-vacio
      [
        forward 1
      ]

      ; Si se recorre en sentido horario

      ; Esto por si el agente se llega a parar en una ubicación desafortunada
      ; en la que no tiene al lado una parte del cuerpo del insecto
      if sentido-horario AND (e-d-rojo AND d-vacio OR a-d-rojo AND d-vacio) AND partes-pintadas = 0 [forward 1]
      if sentido-horario AND d-amarillo AND i-vacio AND e-vacio [forward 1]
      if sentido-horario AND a-d-amarillo AND d-vacio
      [
        right 90
        forward 1
      ]
      if sentido-horario AND e-amarillo AND i-vacio AND (NOT a-d-amarillo OR NOT d-vacio OR NOT d-rojo-2)
      [
        left 90
        forward 1
      ]
      if sentido-horario AND e-amarillo AND i-rojo
      [
        right 180
        forward 1
        right 90
        forward 1
      ]
      if sentido-horario AND e-amarillo AND d-amarillo AND i-amarillo
      [
        right 180
      ]
      if sentido-horario AND d-amarillo AND i-amarillo AND e-vacio
      [
        forward 1
      ]
  ]
end

to pintar
  ask turtles[
    if NOT buscando
    [
      if i-rojo
      [
        ask patch-left-and-ahead 90 1 [set pcolor yellow]
        set partes-pintadas partes-pintadas + 1
        set partes-pintadas-encontradas 0
      ]

      if d-rojo
      [
        ask patch-right-and-ahead 90 1 [set pcolor yellow]
        set partes-pintadas partes-pintadas + 1
        set partes-pintadas-encontradas 0
      ]

      if e-rojo
      [
        ask patch-ahead 1 [set pcolor yellow]
        set partes-pintadas partes-pintadas + 1
        set partes-pintadas-encontradas 0
      ]

      if i-amarillo
      [
        ifelse partes-pintadas-encontradas < 5
        [
          set partes-pintadas-encontradas partes-pintadas-encontradas + 1
        ]
        [
          if partes-pintadas >= 46 AND partes-pintadas <= 60
          [set perforadores-menores-encontrados perforadores-menores-encontrados + 1]
          if partes-pintadas >= 104 AND partes-pintadas <= 120
          [set gusanos-cuarteadores-encontrados gusanos-cuarteadores-encontrados + 1]
          if partes-pintadas >= 86 AND partes-pintadas <= 100
          [set gusanos-perforadores-encontrados gusanos-perforadores-encontrados + 1]
          right 90
          set buscando true
          set partes-pintadas-encontradas 0
          set partes-pintadas 0
          set guiado false
          set posicionado false
        ]
      ]

      if d-amarillo
      [
        ifelse partes-pintadas-encontradas <= 6
        [
          set partes-pintadas-encontradas partes-pintadas-encontradas + 1
        ]
        [
          if partes-pintadas >= 46 AND partes-pintadas <= 60 [set perforadores-menores-encontrados perforadores-menores-encontrados + 1]
          if partes-pintadas >= 104 AND partes-pintadas <= 120 [set gusanos-cuarteadores-encontrados gusanos-cuarteadores-encontrados + 1]
          if partes-pintadas >= 86 AND partes-pintadas <= 100 [set gusanos-perforadores-encontrados gusanos-perforadores-encontrados + 1]
          left 90
          set buscando true
          set partes-pintadas-encontradas 0
          set partes-pintadas 0
          set guiado false
          set posicionado false
        ]
      ]
    ]
  ]

  actualizar-sensores
end

to avanzar
  ask turtles [
    let d-rojo-2 false
    let i-rojo-2 false

    if [pcolor] of patch-right-and-ahead 90 2 = red [set d-rojo-2 true]
    if [pcolor] of patch-left-and-ahead 90 2 = red [set i-rojo-2 true]

    if NOT buscando
    [
      ; Si se recorre en sentido anti-horario

      ; Esto por si el agente se llega a parar en una ubicación desafortunada
      ; en la que no tiene al lado una parte del cuerpo del insecto
      if NOT sentido-horario AND (e-i-rojo AND i-vacio OR a-i-rojo AND i-vacio) AND partes-pintadas = 0 [forward 1]
      if NOT sentido-horario AND i-amarillo AND d-vacio AND e-vacio [forward 1]
      if NOT sentido-horario AND a-i-amarillo AND i-vacio
      [
        left 90
        forward 1
      ]
      if NOT sentido-horario AND e-amarillo AND d-vacio AND (NOT a-i-amarillo OR NOT i-vacio OR NOT i-rojo-2)
      [
        right 90
        forward 1
      ]
      if NOT sentido-horario AND e-amarillo AND d-rojo
      [
        left 180
        forward 1
        left 90
        forward 1
      ]
      if NOT sentido-horario AND e-amarillo AND d-amarillo AND i-amarillo
      [
        left 180
      ]
      if NOT sentido-horario AND d-amarillo AND i-amarillo AND e-vacio
      [
        forward 1
      ]

      ; Si se recorre en sentido horario

      ; Esto por si el agente se llega a parar en una ubicación desafortunada
      ; en la que no tiene al lado una parte del cuerpo del insecto
      if sentido-horario AND (e-d-rojo AND d-vacio OR a-d-rojo AND d-vacio) AND partes-pintadas = 0 [forward 1]
      if sentido-horario AND d-amarillo AND i-vacio AND e-vacio [forward 1]
      if sentido-horario AND a-d-amarillo AND d-vacio
      [
        right 90
        forward 1
      ]

      ; Se agregan las condiciones del final para el caso del perforador menor
      if sentido-horario AND e-amarillo AND i-vacio AND (NOT a-d-amarillo OR NOT d-vacio OR NOT d-rojo-2)
      [
        left 90
        forward 1
      ]
      if sentido-horario AND e-amarillo AND i-rojo
      [
        right 180
        forward 1
        right 90
        forward 1
      ]
      if sentido-horario AND e-amarillo AND d-amarillo AND i-amarillo
      [
        right 180
      ]
      if sentido-horario AND d-amarillo AND i-amarillo AND e-vacio
      [
        forward 1
      ]
    ]
  ]

  actualizar-sensores
end

to establecer-sentido
  ifelse NOT e-rojo
  [
    if heading = 0 OR heading = 90 OR heading = 180 OR heading = 270
    [
      if (d-rojo OR e-d-rojo) OR (patch-right-and-ahead 90 2 = red OR patch-right-and-ahead 45 2 = red)
      [set sentido-horario true]
      if (i-rojo OR e-i-rojo) OR (patch-left-and-ahead 90 2 = red OR patch-right-and-ahead 45 2 = red)
      [set sentido-horario false]
    ]
  ]
  [
    if d-rojo AND i-vacio
    [set sentido-horario true]

    if i-rojo AND d-vacio
    [set sentido-horario false]

    let sentido random 2
    ifelse sentido = 0
    [set sentido-horario false]
    [set sentido-horario true]
  ]

  set sentido-establecido true
end

to guiar
  if e-rojo AND d-vacio AND i-vacio AND (e-d-vacio OR e-i-vacio)
  [
    choca-de-frente
    set guiado true
  ]

  if e-rojo AND d-rojo AND i-vacio AND e-d-vacio AND e-i-vacio
  [
    choca-en-esquina-de-hueco-con-vacio-izquierdo
    set guiado true
  ]

  if e-rojo AND i-rojo AND d-vacio AND e-i-vacio AND e-d-vacio
  [
    choca-en-esquina-de-hueco-con-vacio-derecho
    set guiado true
  ]

  if e-rojo AND d-rojo AND i-rojo AND e-d-rojo AND e-i-rojo AND a-d-rojo AND a-i-rojo
  [
    choca-de-frente-en-hueco
    set guiado true
  ]

  if e-i-rojo AND e-d-rojo AND a-i-vacio AND a-d-vacio
  [
    acercamiento-a-hueco
    set guiado true
  ]

  if e-i-rojo AND e-d-vacio AND d-vacio
  [
    choque-oblicuo-derecha-nada
    set guiado true
  ]

  if e-d-rojo AND e-i-vacio AND i-vacio
  [
    choque-oblicuo-izquierda-nada
    set guiado true
  ]

  if e-rojo AND d-rojo AND i-rojo AND e-d-rojo AND e-i-rojo AND a-d-vacio AND a-i-vacio
  [
    choque-agente-se-encierra
    set guiado true
  ]
end

to choca-de-frente
  set choque-frontal true

  if heading > 45 AND heading < 135
  [
    ifelse heading > 45 AND heading < 90
    [set heading 0]
    [set heading 180]
  ]

  if heading > 135 AND heading < 225
  [
    ifelse heading > 135 AND heading < 180
    [set heading 90]
    [set heading 270]
  ]

  if heading > 225 AND heading < 315
  [
    ifelse heading > 225 AND heading < 270
    [set heading 180]
    [set heading 0]
  ]

  if (heading > 315 AND heading < 360) OR (heading >= 0 AND heading < 45)
  [
    ifelse heading > 315 AND heading < 360
    [set heading 270]
    [set heading 90]
  ]

  set choque-frontal false
end

to choca-en-esquina-de-hueco-con-vacio-izquierdo
  set choca-en-esquina-vacio-izquierda true

  if heading > 0 AND heading < 90
  [set heading 90]

  if heading > 90 AND heading < 180
  [set heading 180]

  if heading > 180 AND heading < 270
  [set heading 270]

  if heading > 270 AND heading < 360
  [set heading 0]

  set choca-en-esquina-vacio-izquierda false
end

to choca-en-esquina-de-hueco-con-vacio-derecho
  set choca-en-esquina-vacio-derecha true

  if heading > 0 AND heading < 90
  [set heading 90]

  if heading > 90 AND heading < 180
  [set heading 180]

  if heading > 180 AND heading < 270
  [set heading 270]

  if heading > 270 AND heading < 360
  [set heading 0]

  set choca-en-esquina-vacio-derecha false
end

to choca-de-frente-en-hueco
  set choque-hueco-angosto true

  if heading > 45 AND heading < 135
  [set heading 270]

  if heading > 135 AND heading < 225
  [set heading 0]

  if heading > 225 AND heading < 315
  [set heading 90]

  if heading > 315 AND heading < 360 OR heading >= 0 AND heading < 45
  [set heading 180]

  set choque-hueco-angosto false
end

to acercamiento-a-hueco
  set se-acerca-a-hueco true

  if heading > 0 AND heading < 90
  [set heading 90]

  if heading > 90 AND heading < 180
  [set heading 180]

  if heading > 180 AND heading < 270
  [set heading 270]

  if heading > 270 AND heading < 360
  [set heading 0]

  set se-acerca-a-hueco false
end

to choque-oblicuo-derecha-nada
  set choca-oblicuamente-derecha-nada true

  if heading > 0 AND heading < 90
  [set heading 90]

  if heading > 90 AND heading < 180
  [set heading 180]

  if heading > 180 AND heading < 270
  [set heading 270]

  if heading > 270 AND heading < 360
  [set heading 0]

  set choca-oblicuamente-derecha-nada false
end

to choque-oblicuo-izquierda-nada
  set choca-oblicuamente-izquierda-nada true

  if heading > 0 AND heading < 90
  [set heading 90]

  if heading > 90 AND heading < 180
  [set heading 180]

  if heading > 180 AND heading < 270
  [set heading 270]

  if heading > 270 AND heading < 360
  [set heading 0]

  set choca-oblicuamente-izquierda-nada false
end

to choque-agente-se-encierra
  set choque-oblicuo-rodeado true

  if heading > 0 AND heading < 90
  [
    ifelse heading > 0 AND heading < 45
    [set heading 270]
    [set heading 180]
  ]

  if heading > 90 AND heading < 180
  [
    ifelse heading > 90 AND heading < 135
    [set heading 0]
    [set heading 270]
  ]

  if heading > 180 AND heading < 270
  [
    ifelse heading > 180 AND heading < 270
    [set heading 90]
    [set heading 0]
  ]

  if heading > 270 AND heading < 360
  [
    ifelse heading > 270 AND heading < 315
    [set heading 180]
    [set heading 90]
  ]

  set choque-oblicuo-rodeado false
end

to posicionar
  let posx 0
  let posy 0

  ifelse e-vacio
  [
    if d-rojo
    [
      if heading = 0
      [
        ask patch-right-and-ahead 90 1 [
          set posx pxcor - 1
          set posy pycor
        ]
      ]
      if heading = 90
      [
        ask patch-right-and-ahead 90 1 [
          set posx pxcor
          set posy pycor + 1
        ]
      ]
      if heading = 180
      [
        ask patch-right-and-ahead 90 1 [
          set posx pxcor + 1
          set posy pycor
        ]
      ]
      if heading = 270
      [
        ask patch-right-and-ahead 90 1 [
          set posx pxcor
          set posy pycor - 1
        ]
      ]
    ]

    if i-rojo
    [
      if heading = 0
      [
        ask patch-left-and-ahead 90 1 [
          set posx pxcor + 1
          set posy pycor
        ]
      ]
      if heading = 90
      [
        ask patch-left-and-ahead 90 1 [
          set posx pxcor
          set posy pycor + 1
        ]
      ]
      if heading = 180
      [
        ask patch-left-and-ahead 90 1 [
          set posx pxcor - 1
          set posy pycor
        ]
      ]
      if heading = 270
      [
        ask patch-left-and-ahead 90 1 [
          set posx pxcor
          set posy pycor - 1
        ]
      ]
    ]
  ]
  [
    if heading = 0
    [
      ask patch-ahead 1 [
        set posx pxcor
        set posy pycor - 1
      ]
    ]
    if heading = 90
    [
      ask patch-ahead 1 [
        set posx pxcor - 1
        set posy pycor
      ]
    ]
    if heading = 180
    [
      ask patch-ahead 1 [
        set posx pxcor
        set posy pycor + 1
      ]
    ]
    if heading = 270
    [
      ask patch-ahead 1 [
        set posx pxcor + 1
        set posy pycor
      ]
    ]
  ]

  setxy posx posy

  ; Si falla la posición, buscar otra vez desde el origen
  if posx = 0 AND posy = 0
  [
    set buscando true
    set guiado false
    stop
  ]

  ifelse [pcolor] of patch-ahead 1 = red [set e-rojo true] [set e-rojo false]
  ifelse [pcolor] of patch-right-and-ahead 90 1 = red [set d-rojo true] [set d-rojo false]
  ifelse [pcolor] of patch-left-and-ahead 90 1 = red [set i-rojo true] [set i-rojo false]
  ifelse [pcolor] of patch-right-and-ahead 45 1 = red [set e-d-rojo true] [set e-d-rojo false]
  ifelse [pcolor] of patch-left-and-ahead 45 1 = red [set e-i-rojo true] [set e-i-rojo false]
  ifelse [pcolor] of patch-right-and-ahead 135 1 = red [set a-d-rojo true] [set a-d-rojo false]
  ifelse [pcolor] of patch-left-and-ahead 135 1 = red [set a-i-rojo true] [set a-i-rojo false]

  ifelse [pcolor] of patch-ahead 1 = yellow [set e-amarillo true] [set e-amarillo false]
  ifelse [pcolor] of patch-right-and-ahead 90 1 = yellow [set d-amarillo true] [set d-amarillo false]
  ifelse [pcolor] of patch-left-and-ahead 90 1 = yellow [set i-amarillo true] [set i-amarillo false]
  ifelse [pcolor] of patch-right-and-ahead 45 1 = yellow [set e-d-amarillo true] [set e-d-amarillo false]
  ifelse [pcolor] of patch-left-and-ahead 45 1 = yellow [set e-i-amarillo true] [set e-i-amarillo false]
  ifelse [pcolor] of patch-right-and-ahead 135 1 = yellow [set a-d-amarillo true] [set a-d-amarillo false]
  ifelse [pcolor] of patch-left-and-ahead 135 1 = yellow [set a-i-amarillo true] [set a-i-amarillo false]

  ifelse [pcolor] of patch-ahead 1 = black [set e-vacio true] [set e-vacio false]
  ifelse [pcolor] of patch-right-and-ahead 90 1 = black [set d-vacio true] [set d-vacio false]
  ifelse [pcolor] of patch-left-and-ahead 90 1 = black [set i-vacio true] [set i-vacio false]
  ifelse [pcolor] of patch-right-and-ahead 45 1 = black [set e-d-vacio true] [set e-d-vacio false]
  ifelse [pcolor] of patch-left-and-ahead 45 1 = black [set e-i-vacio true] [set e-i-vacio false]
  ifelse [pcolor] of patch-right-and-ahead 135 1 = black [set a-d-vacio true] [set a-d-vacio false]
  ifelse [pcolor] of patch-left-and-ahead 135 1 = black [set a-i-vacio true] [set a-i-vacio false]

  ; Si falla el posicionamiento del agente, que siga buscando un insecto
  if d-vacio AND i-vacio AND e-vacio AND (a-i-rojo OR a-d-rojo)
  [
    set guiado false
    set buscando true
    stop
  ]

  establecer-sentido

  if patch-left-and-ahead 180 1 = red
  [
    ifelse sentido-horario
    [
      if heading = 0 [set heading 90]
      if heading = 90 [set heading 180]
      if heading = 180 [set heading 270]
      if heading = 270 [set heading 0]
    ]
    [
      if heading = 0 [set heading 270]
      if heading = 90 [set heading 0]
      if heading = 180 [set heading 90]
      if heading = 270 [set heading 180]
    ]
  ]

  set posicionado true
end
@#$#@#$#@
GRAPHICS-WINDOW
326
56
4247
2678
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-150
150
-100
100
0
0
1
ticks
30.0

BUTTON
56
241
296
427
NIL
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
56
456
292
588
NIL
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

BUTTON
61
616
297
797
NIL
identificar
T
1
T
OBSERVER
NIL
I
NIL
NIL
1

MONITOR
4306
516
4892
722
Perforadores menores
perforadores-menores-encontrados
17
1
50

MONITOR
4311
1061
4912
1267
Gusanos cuarteadores
gusanos-cuarteadores-encontrados
17
1
50

MONITOR
4316
1656
4902
1862
Gusanos perforadores
gusanos-perforadores-encontrados
17
1
50

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
