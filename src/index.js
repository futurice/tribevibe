import "./main.css";
import "./card.css";
import C3 from "c3";

import { Main } from "./Main.elm";

// Unregister service workers
navigator.serviceWorker.getRegistrations().then(function(registrations) {
  for (let registration of registrations) {
    registration.unregister();
  }
});

const app = Main.embed(document.getElementById("root"));

app.ports.drawGraph.subscribe(function(engagement) {
  const values = engagement.values.map(v => v.value);
  // Hack to draw to graph after the element is present
  const minValue = Math.floor(Math.min.apply(null, values) - 1);
  const maxValue = Math.ceil(Math.max.apply(null, values) + 1);
  // Dirty trick to avoid lodash.range(maxValue - minValue)
  const yTicks = Array((maxValue - minValue) * 2)
    .fill()
    .map((_, i) => ({ value: minValue + (i + 1) * 0.5 }));

  requestAnimationFrame(() =>
    C3.generate({
      bindto: "#graph-container",
      data: {
        columns: [["engagement", ...values]],
        type: "spline"
      },
      color: {
        pattern: ["#BADA55"]
      },
      axis: {
        y: {
          min: Math.max(0, minValue),
          max: Math.min(10, maxValue),
          padding: {
            top: 0,
            bottom: 0
          }
        }
      },
      grid: {
        x: {
          show: true // lines: [ minValue, maxValue ]
        },
        y: {
          lines: yTicks
        }
      }
    })
  );
});
