import './main.css';
import C3 from 'c3';

import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const app = Main.embed(document.getElementById('root'));

registerServiceWorker();

app.ports.drawGraph.subscribe(function (data) {
    // Hack to draw to graph after the element is present
    setTimeout(() => C3.generate({
        bindto: '#graph-container',
        data: {
          columns: [
            ['engagement', ...data[0].values],
          ]
        },
        axis: {
            y: {
                min: Math.floor(Math.min.apply(null, data[0].values) - 1),
                max: Math.ceil(Math.max.apply(null, data[0].values) + 1),
                padding: {
                    top:0, 
                    bottom:0
                }
            }
        }
    }), 500);
    console.table(data);
    console.log('Drawing scam values because of missing Engagement'); 
});