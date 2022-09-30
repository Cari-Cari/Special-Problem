;; Submitted by: RICA BERNADINE M. CALBARIO
;;               BS Computer Science
;; Submitted to: Sir JOEL M. ADDAWE
;;               Thesis Adviser
;;
;;    Department of Mathematics and Computer Science
;;    College of Science
;;    University of the Philippines Baguio

turtles-own [
  opinion ;; a list of "A" or "B" or both
  committed?
]

;;;;;;;;;;;;;;;
;;;; Setup ;;;;
;;;;;;;;;;;;;;;

to setup
  clear-all
  setup-nodes
  ask n-of initial-minority turtles
    [ become-minority ]
  setup-minority-media
  setup-majority-media
  setup-spatially-clustered-network
  ask links [ set color white ]
  reset-ticks
end

to setup-nodes
  set-default-shape turtles "circle"
  create-turtles N
  [
    ; for visual reasons, we don't put any nodes *too* close to the edges
    setxy (random-xcor * 0.95) (random-ycor * 0.95)
    become-majority
  ]
end

to setup-minority-media
  create-turtles number-of-minority-media
  [
    setxy (random-xcor * 0.95) (random-ycor * 0.95)
    become-minority-media
  ]
end

to setup-majority-media
  create-turtles number-of-majority-media
  [
    setxy (random-xcor * 0.95) (random-ycor * 0.95)
    become-majority-media
  ]
end

to setup-spatially-clustered-network
  let num-links (average-node-degree * N) / 2
  while [count links < num-links ]
  [
    ask one-of turtles
    [
      let choice (min-one-of (other turtles with [not link-neighbor? myself])
                   [distance myself])
      if choice != nobody [ create-link-with choice ]
    ]
  ]
  ; make the network look a little prettier
  repeat 10
  [
    layout-spring turtles links 0.3 (world-width / (sqrt N)) 1
  ]
end

to become-minority
  set opinion ["A"]
  set committed? false
  set color blue
end

to become-majority
  set opinion ["B"]
  set committed? false
  set color red
end

to become-committed-minority
  set opinion ["A"]
  set committed? true
  set color yellow
end

to become-minority-media
  set opinion ["A"]
  set committed? true
  set color green
  set size 2
end

to become-majority-media
  set opinion ["B"]
  set committed? true
  set color orange
  set size 2
end

;;;;;;;;;;;;
;;;; Go ;;;;
;;;;;;;;;;;;

to go
  let min-A (count turtles with [opinion = ["A"] and committed? = false ]) / 2
  let maj-B (count turtles with [opinion = ["B"] and committed? = false ]) / 2

  ask one-of turtles [ interact ]
  if ticks mod plotting-interval = 0
  [  my-update-plots  ]
  tick
  if (count turtles with [opinion = ["B"] and committed? = false ] = 0 or count turtles with [opinion = ["A"] and committed? = false ] = 0) [stop]
end

to color-agent
  if member? "A" opinion [ set color blue ]
  if member? "B" opinion [ set color red ]
end

to interact
  let listener one-of link-neighbors
  speak-to listener

end

to speak-to [listener]
  let voice one-of opinion                               ;; voice is a string

  if [committed?] of listener != true [                  ;; if its not true that the listener is not committed continue, if committed, reiterate again
    ifelse member? voice [opinion] of listener           ;; if the listener already has that opinion
    [ ask listener [
      set opinion filter [ ?1 -> ?1 = voice ] opinion    ;; set opinion as the voice (if the selected voice has "A" "B", it would end up just having A)
      color-agent                                        ;; colors the node to the right color
    ] ]
    [ ask listener [                                     ;; if the listener is not the same of the voice, set as "A" "B" then reiterate again
      set opinion ["A" "B"]
  ] ] ]
end

to my-update-plots
  set-current-plot "Opinion Shares"
  set-plot-pen-interval plotting-interval
  set-current-plot-pen "Minor"
  plot (count turtles with [opinion = ["A"] and committed? = false ]) / (N + 2 - number-of-minority-media - number-of-majority-media)
  set-plot-pen-interval plotting-interval
  set-current-plot-pen "Major"
  plot (count turtles with [opinion = ["B"] and committed? = false ]) / (N + 2 - number-of-minority-media - number-of-majority-media)
end

;; target turtles with lots of links or with few links
;to commit-high-degree [ fraction ]
  ;; target the highest
  ;;ask turtle-set sublist sort-by [ [?1 ?2] -> [count link-neighbors] of ?1 > [count link-neighbors] of ?2 ] turtles 0 int(N * fraction)
  ;;[ set committed? true
  ;;  set opinion ["M"]
  ;;  color-agent
  ;;]

  ;;set minority (((N) * 0.10) - 1)
 ; set rounded (N * fraction)
 ; set ceil ceiling rounded
 ; ask n-of int(ceil) turtles
 ; [
 ;   set opinion ["M"]
 ;   set committed? true
 ;   color-agent
 ; ]
;end

;to commit-randomly [ fraction ]
;  set minority ((N) * 0.10)
;  set rounded (minority * fraction)
;  set ceil ceiling rounded
;  ask n-of int(ceil) turtles
;  [
;    set opinion ["A"]
;    set committed? true
;    color-agent
;  ]

;end

;to commit-low-degree [ fraction ]
;  ask turtle-set sublist sort-by [ [?1 ?2] -> [count link-neighbors] of ?1 < [count link-neighbors] of ?2 ] turtles 0 int(N * fraction)
;  [ set committed? true
;    set opinion ["A"]
;    color-agent
;  ]
;end
@#$#@#$#@
GRAPHICS-WINDOW
260
50
794
585
-1
-1
8.623
1
10
1
1
1
0
0
0
1
-30
30
-30
30
0
0
1
ticks
30.0

SLIDER
30
105
220
138
N
N
0
1000
100.0
1
1
NIL
HORIZONTAL

BUTTON
30
70
220
103
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
955
245
1012
290
Minor
count turtles with [opinion = [\"A\"] and committed? = false ] / (N + 2)
1
1
11

MONITOR
1015
245
1072
290
Major
count turtles with [opinion = [\"B\"]] / (N + 2)
1
1
11

BUTTON
30
300
235
333
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
806
45
1131
240
Opinion Shares
time
Share
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Major" 1.0 0 -2674135 true "" ""
"Minor" 1.0 0 -13345367 true "" ""

SLIDER
805
250
950
283
plotting-interval
plotting-interval
1
1000
1.0
1
1
NIL
HORIZONTAL

TEXTBOX
30
50
180
68
Basic setup
12
0.0
1

TEXTBOX
30
285
180
303
Running the model
12
0.0
1

SLIDER
30
210
222
243
number-of-minority-media
number-of-minority-media
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
30
175
220
208
average-node-degree
average-node-degree
0
10
6.0
1
1
NIL
HORIZONTAL

SLIDER
30
140
220
173
initial-minority
initial-minority
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
30
245
222
278
number-of-majority-media
number-of-majority-media
0
100
0.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This model studies how public speaking or announcements affect social decision via an influential speaker. Social decision is measured by the opinions present in the network of agents. Speakers try to influence listeners to match their opinion. In this situation, some agents are committed and will not change their opinion no matter what opinion the speaker has.

## HOW IT WORKS

Each agent can have one or both of the opinions "A" and "B". For each tick of the simulation, one agent is randomly selected to be the speaker. This speaker then interacts with one of its neighbors, called the listener. One opinion of the speaker is randomly chosen and called the voice, if the listener has that same opinion, whether by itself or with the other opinion, then the listener's opinion is changed to match the voice. If the listener does not have that opinion, then its opinion is changed to include both "A" and "B". However, if the listener was already marked as committed, then it will not change its opinion at all. All committed agents have opinion "A" only. This process repeats, with a speaker randomly selected each tick, until there are no more "B" opinions present.

## HOW TO USE IT

There are two options to setup the simulation. The basic setup version creates a network of agents using the N, m0, and m variables. These agents are randomly assigned an opinion of "A", "B", or ["A" "B"]. Depending on the p-commit variable, some of these agents are committed to "A". The Setup with positions version follows the same setup procedure, but it selects additional agents to be committed to "A". There are three options for this selection. 1) low-degree selects agents that have few links, 2) high-degree selects agents that have many links, and 3) randomly selects a random number of agents to be committed. The number of agents newly selected to be committed depends on the commitment-percentage variable.

After the agents are created, press the Layout button to aid in visualization. Press it again to stop the movement. The Layout selectively option keeps all the "B" agents position intact relative to one another while the "A" and ["A" "B"] agents are free to move as normal. In addition, by selecting On from the manual-layout? switcher, you can use the spring-length, repulsion-constant, and spring-constant sliders to adjust the layout options.

Once you are satisfied with the layout, you may start the simulation. Press the Go button to run the simulation. The colors of the agents will change to match their new opinions. You can track the opinion shares using the plot on the right side of the interface. The monitor boxes give the exact shares of each opinion as well as the share of committed agents. Note that the A opinion monitor box is the share of agents with opinion "A" who are not committed. The six additional visualization options may also help in your analysis of the simulation.


## THINGS TO NOTICE

Notice what happens to the share of "A" opinions over time and how that varies based on the number of committed agents. Use the various Setup with positions options to see how commitment in high- vs low-linked agents affects the share of opinions.

## THINGS TO TRY

Adjust the various parameters that affect the number of committed agents. In particular, see what happens when there are no committed agents and how that compares to simulations with committed agents. 

## EXTENDING THE MODEL

Given that this simulation only includes agents who are committed to "A", it may be interesting to study what happens when agents can also be committed to "B". How would this affect the long-run opinion shares of the agent network? 

In this model, commitment is either all or nothing. In the face of a different opinion, either an agent never changes its opinion, or it always changes its opinion. It may be interesting to study what happens if a non-committed agent does not always change its opinion when faced with a voice that does not match its opinion. This may also be a more realistic situation than the one currently simulated.

## RELATED MODELS

Axelrod
Confident Voter
Heterogeneous Voter
Ising
Potts
Turnout
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
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

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
<experiments>
  <experiment name="TEST random" repetitions="1" runMetricsEveryStep="false">
    <setup>setup
commit-randomly commitment-percentage</setup>
    <go>go</go>
    <timeLimit steps="20000000"/>
    <exitCondition>count turtles with [opinion = ["B"]] = 0</exitCondition>
    <metric>ticks</metric>
    <metric>count turtles with [opinion = ["B"]]</metric>
    <enumeratedValueSet variable="p-commit">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="commitment-percentage">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spring-constant">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="manual-layout?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="m">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="plotting-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="m0">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="repulsion-constant">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spring-length">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="N">
      <value value="500"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Convergence time - commitment percentage" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-with-positions</setup>
    <go>go</go>
    <timeLimit steps="10000000"/>
    <metric>ticks</metric>
    <metric>(count turtles with [opinion = ["B"]] )/ N</metric>
    <enumeratedValueSet variable="commitment-percentage">
      <value value="0.05"/>
      <value value="0.1"/>
      <value value="0.15"/>
      <value value="0.2"/>
      <value value="0.25"/>
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="positioning">
      <value value="&quot;high-degree&quot;"/>
      <value value="&quot;randomly&quot;"/>
      <value value="&quot;low degree&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="manual-layout?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="m0">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spring-length">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="p-commit">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="N">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="spring-constant">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="plotting-interval">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="m">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="repulsion-constant">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
1
@#$#@#$#@
