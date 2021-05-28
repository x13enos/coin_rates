import Chart from 'chart.js/auto';
import {connectToChannel} from "./socket"
import 'chartjs-adapter-luxon';

const exponentialToDecimal = exponential => {
  let decimal = exponential.toString().toLowerCase();
  if (decimal.includes('e+')) {
      const exponentialSplitted = decimal.split('e+');
      let postfix = '';
      for (
          let i = 0;
          i <
          +exponentialSplitted[1] -
              (exponentialSplitted[0].includes('.') ? exponentialSplitted[0].split('.')[1].length : 0);
          i++
      ) {
          postfix += '0';
      }
      const addCommas = text => {
          let j = 3;
          let textLength = text.length;
          while (j < textLength) {
              text = `${text.slice(0, textLength - j)},${text.slice(textLength - j, textLength)}`;
              textLength++;
              j += 3 + 1;
          }
          return text;
      };
      decimal = addCommas(exponentialSplitted[0].replace('.', '') + postfix);
  }
  if (decimal.toLowerCase().includes('e-')) {
      const exponentialSplitted = decimal.split('e-');
      let prefix = '0.';
      for (let i = 0; i < +exponentialSplitted[1] - 1; i++) {
          prefix += '0';
      }
      decimal = prefix + exponentialSplitted[0].replace('.', '');
  }
  return decimal;
};

const coinSlugs = Object.keys(window.chart_data);
const charts = {};
coinSlugs.forEach((slug) => {
  const ctx = document.getElementById(`lineChart-${slug}`).getContext("2d");
  charts[slug] = new Chart(ctx, {
    type: "line",
    data: {
      labels: window.chart_labels[slug],
      bezierCurve: false,
      datasets: [
        {
          borderColor: "red",
          borderWidth: 1,
          lineTension: 0.25,
          data: window.chart_data[slug],
        },
      ],
    },
    options: {
      plugins: {
        legend: {
            display: false,
        }
      },
      elements: {
        point:{
            radius: 0
        }
      },
      scales: {
        y: {
          ticks: {
            callback: function (value, index, values) {
              return exponentialToDecimal(value)
            }
          }
        },
        x: {
          type: 'time',
          time: {
            minUnit: "minute",
            displayFormats: {
              hour: 'HH:mm'
            }
          },
          grid: {
            drawOnChartArea: false
          },
          ticks: {
            source: 'auto',
            // Disabled rotation for performance
            maxRotation: 0,
            autoSkip: true,
            maxTicksLimit: 12
          }
        }
      }
    },
  });

  connectToChannel({
    channel_name: `chart:${slug}`,
    update_callback: (payload) => {
      charts[slug].data.labels.push(payload.label);
      charts[slug].data.datasets.forEach((dataset) => {
          dataset.data.push(payload.value);
      });
      charts[slug].update();
    }
  })

})