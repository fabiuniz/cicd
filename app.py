from flask import Flask, render_template_string
import os
from datetime import datetime
import pytz

app = Flask(__name__)

# Template HTML com design simples e elegante
HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World - Flask App</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        
        .container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 3rem;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.2);
            max-width: 600px;
            width: 90%;
        }
        
        h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            animation: fadeInUp 1s ease-out;
        }
        
        .subtitle {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
            animation: fadeInUp 1s ease-out 0.3s both;
        }
        
        .time-card {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            padding: 2rem;
            margin: 2rem 0;
            animation: fadeInUp 1s ease-out 0.6s both;
        }
        
        .time {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        
        .date {
            font-size: 1.1rem;
            opacity: 0.8;
        }
        
        .status {
            background: rgba(76, 175, 80, 0.3);
            border: 1px solid rgba(76, 175, 80, 0.5);
            border-radius: 25px;
            padding: 0.8rem 1.5rem;
            display: inline-block;
            margin-top: 2rem;
            animation: fadeInUp 1s ease-out 0.9s both;
        }
        
        .status::before {
            content: "🚀 ";
            margin-right: 0.5rem;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .footer {
            margin-top: 2rem;
            font-size: 0.9rem;
            opacity: 0.7;
            animation: fadeInUp 1s ease-out 1.2s both;
        }
        
        @media (max-width: 768px) {
            h1 {
                font-size: 2rem;
            }
            
            .container {
                padding: 2rem;
            }
            
            .time {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hello World CI/CD! 👋</h1>
        <p class="subtitle">Flask App Dockerizada com Deploy Automatizado</p>
        
        <div class="time-card">
            <div class="time">{{ time }}</div>
            <div class="date">{{ date }}</div>
            <div style="margin-top: 1rem; opacity: 0.8;">
                📍 São Paulo, Brasil ({{ timezone }})
            </div>
        </div>
        
        <div class="status">
            Deploy realizado com sucesso no Google Cloud Run
        </div>
        
        <div class="footer">
            Powered by Flask + Docker + GitHub Actions + GCP Cloud Run
        </div>
    </div>
</body>
</html>
"""

@app.route('/')
def hello_world():
    # Timezone de São Paulo
    sao_paulo_tz = pytz.timezone('America/Sao_Paulo')
    now_sao_paulo = datetime.now(sao_paulo_tz)
    
    # Formatação da data e hora
    time_str = now_sao_paulo.strftime('%H:%M:%S')
    date_str = now_sao_paulo.strftime('%d de %B de %Y')
    timezone_str = now_sao_paulo.strftime('%Z%z')
    
    return render_template_string(
        HTML_TEMPLATE, 
        time=time_str, 
        date=date_str, 
        timezone=timezone_str
    )

@app.route('/health')
def health():
    return {'status': 'healthy', 'timestamp': datetime.now().isoformat()}

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)