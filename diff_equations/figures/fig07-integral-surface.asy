// Рисунок 7. Поверхность z = u(x,y) = y e^{-kx} — интеграл уравнения y' = ky.
// Сечения плоскостями z = C дают линии уровня; их проекции на Oxy —
// интегральные кривые y = C e^{kx}.
// Сборка: asy -f pdf -noprc -render=0 fig07-integral-surface.asy
import graph3;
size(11cm, 8cm, IgnoreAspect);
currentprojection = orthographic(5, 3.2, 3.2);
currentlight = nolight;
real k    = 1;
real xmax = 2;
real ymax = 3;
real u(real x, real y) { return y*exp(-k*x); }
// ---------- перья ----------
// выделенная линия: RGB(195,60,120), ultra thick (1.6pt)
// остальные кривые: RGB(82,121,165), сплошные, thick (0.8pt)
pen hlp     = rgb(195/255, 60/255, 120/255) + 1.6pt;
pen auxp    = rgb(82/255, 121/255, 165/255) + 0.8pt;
pen auxlite = gray(0.5) + 0.5pt + linetype("2 2", scale=false);
pen surfpen = gray(0.90) + opacity(0.5);
pen meshp   = gray(0.6) + 0.25pt;
pen axpen   = black + 0.5pt;
// ---------- поверхность ----------
triple F(pair t) { return (t.x, t.y, u(t.x, t.y)); }
surface S = surface(F, (0,0), (xmax,ymax), 8, 8, Spline);
draw(S, surfacepen = surfpen, meshpen = meshp);
// ---------- секущая плоскость z = C2 ----------
real C1 = 0.4, C2 = 0.8, C3 = 1.3;
path3 plane = (0,0,C2) -- (xmax,0,C2) -- (xmax,ymax,C2) -- (0,ymax,C2) -- cycle;
draw(surface(plane), gray(0.75) + opacity(0.18));
draw(plane, gray(0.55) + 0.35pt);
// ---------- оси ----------
draw(O -- (xmax + 0.75, 0, 0), axpen, Arrow3(TeXHead2));
draw(O -- (0, ymax + 0.75, 0), axpen, Arrow3(TeXHead2));
draw(O -- (0, 0, 3.20),        axpen, Arrow3(TeXHead2));
label("$x$", (xmax + 0.95, 0, 0));
label("$y$", (0, ymax + 0.95, 0));
label("$z$", (0, 0, 3.40));
// ---------- линии уровня и их проекции ----------
// линия уровня u = C обрывается там, где y = C e^{kx} выходит за ymax
real xtop(real C) { return min(xmax, log(ymax/C)/k); }
path3 level(real C) {
  return graph(new triple(real t) { return (t, C*exp(k*t), C); },
               0, xtop(C), 80, operator ..);
}
path3 proj(real C) {
  return graph(new triple(real t) { return (t, C*exp(k*t), 0); },
               0, xtop(C), 80, operator ..);
}
draw(level(C1), auxp);  draw(proj(C1), auxp);
draw(level(C3), auxp);  draw(proj(C3), auxp);
draw(level(C2), hlp);   draw(proj(C2), hlp);
// вертикальные связки «линия уровня — её проекция»
real xe = xtop(C2), ye = C2*exp(k*xe);
draw((0, C2, C2) -- (0, C2, 0), auxlite);
draw((xe, ye, C2) -- (xe, ye, 0), auxlite);
// ---------- подписи ----------
// разведены по разным направлениям, чтобы не ложиться на кривые
label("$z = C_2$", (xmax, 0, C2), 2W, gray(0.35));
label("$u = C_2$", (xe, ye, C2), 6NE, hlp);
label("$y = C_2 e^{kx}$", (xe, ye, 0), 4E, hlp);
