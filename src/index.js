import "./main.css";
import "./card.css";
import C3 from "c3";

import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";

const app = Main.embed(document.getElementById("root"));

registerServiceWorker();

app.ports.drawGraph.subscribe(function(engagement) {
  const sortedValues = engagement.values.sort((a, b) => a.date > b.date)
  const values = sortedValues.map(v => v.value);
  const timeStamps = sortedValues.map(v => v.date);

  // Hack to draw to graph after the element is present
  const minValue = Math.floor(Math.min.apply(null, values) - 1);
  const maxValue = Math.ceil(Math.max.apply(null, values) + 1);
  // Dirty trick to avoid lodash.range(maxValue - minValue)
  const yTicks = Array((maxValue - minValue + 0.5) * 2)
    .fill()
    .map((_, i) => ({ value: minValue + i * 0.5 }));

  const chartRendered = () => {
    const svg = document.getElementById('graph-container').querySelector('svg');
    const svgDefs = svg.querySelector('defs');
    const existingGradient = svgDefs.getElementsByTagName('linearGradient');
    if (existingGradient.length > 0) {
      svgDefs.removeChild(existingGradient[0]);
    }
    const absoluteHeight = svg.querySelector('.c3-grid-lines').getBoundingClientRect().height;

    const projectedHeight = absoluteHeight * (10/(maxValue - minValue));
    const step = projectedHeight / 10;
    const y0 = -(10 - maxValue) * step;

    /*
      Stops:
      10%: 9.0
      25%: 7.5
      40%: 6.0
      100%: 0
    */
    svgDefs.innerHTML += `<linearGradient id="engagement-gradient" x1="0%" x2="0%" y1="${y0}px" y2="${y0 + projectedHeight}px" gradientUnits="userSpaceOnUse">
    <stop offset="10%" stop-color="#00FF00"></stop>
    <stop offset="25%" stop-color="#fffb00"></stop>
    <stop offset="40%" stop-color="#FF0000"></stop>
    <stop offset="100%" stop-color="#000000">
    </linearGradient>`

  };

  requestAnimationFrame(() => {
    const chart = C3.generate({
      bindto: "#graph-container",
      onrendered: chartRendered,
      padding: {
        top: 20,
        right: 20,
        bottom: 10,
        left: 50,
      },
      legend: {
        hide: true,
      },
      data: {
        x: 'x',
        xFormat: '%Y-%m-%d',
        columns: [
          ["x", ...timeStamps],
          ["engagement", ...values]],
        type: "spline"
      },
      color: {
        pattern: ["url(#engagement-gradient)"]
      },
      axis: {
        x: {
          type: 'timeseries',
          tick: {
            format: '%-m/%-y',
          }
        },
        y: {
          min: Math.max(0, minValue),
          max: Math.min(10, maxValue),
          tick: {
            values: yTicks.map(v => Math.round(v.value))
          }
        }
      },
      point: {
        show: false,
      },
      grid: {
        lines: {
          front: false,
        },
        x: {
          show: false,
          lines: timeStamps.map(s => ({ value: s })),
        },
        y: {
          lines: yTicks
        }
      }
    });
  });
});
