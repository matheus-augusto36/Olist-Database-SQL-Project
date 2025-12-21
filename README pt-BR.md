# 📊 Business Insights from Reviews

---

Este projeto tem como objetivo **extrair insights iniciais de negócio a partir de reviews de clientes usando SQL**.  
A análise das avaliações permite compreender melhor a percepção dos consumidores, identificar pontos fortes, detectar oportunidades de melhoria e apoiar decisões estratégicas.

### 🚀 Objetivos
- Coletar e organizar reviews de clientes.
- Identificar padrões com base nas avaliações (score de 1 a 5).  
- Gerar métricas e visualizações que apoiem decisões de negócio.  

### 🛠️ Tecnologias/Conceitos Utilizados
- SQL  
- JOIN  
- Subqueries  
- Estrutura WITH  
- Cálculo de percentuais  

### 📈 Análise
Obs: Utilização de amostra (tabela de avaliações) de 25305 registros, de uma base com total de 96461 pedidos registrados (cerca de 25%).
- Cerca de 77% dos pedidos avaliados da amostra receberam boa pontuação (4 e 5);
  
  <img width="223" height="74" alt="image" src="https://github.com/user-attachments/assets/a040fe4f-5b9d-400c-b202-e5d9cdc73fbe" />


- As categorias com mais de 20% de avaliações ruins representam, juntas, 80% de todos os pedidos com avaliações insatisfatórias da amostra.

  <img width="205" height="56" alt="image" src="https://github.com/user-attachments/assets/cfcb112e-4920-4356-a57d-bf58ea91095a" />


- As categorias de produto com mais avaliações ruins são: fraldas_higiene, fashion_roupa_masculina, telefonia_fixa, audio e moveis_escritorio.
Para avaliar a representatividade dessas categorias em relação ao total da amostra, foi calculado o percentual de pedidos para cada uma delas e constatou-se que elas não tem impacto relevante no negócio (representam cerca de 2,2% do total de pedidos da amostra)

  <img width="571" height="116" alt="image" src="https://github.com/user-attachments/assets/0ce74139-1398-4ee4-8011-686c0280e0f3" />

- Em contrapartida, foram calculadas as categorias de produto mais representativas com base no percentual de número de pedidos, todas com mais de 20% de avaliações ruins.
  
  <img width="598" height="137" alt="image" src="https://github.com/user-attachments/assets/f5dfa890-a06a-44a2-8a7e-c8dd75edb62f" />

- Após calcular o percentual de pedidos com atraso na entrega, constatou-se que em cada uma dessas categorias de produto há atraso na entrega em cerca de 67% a 76% dos pedidos na amostra. Isso mostra que problemas com delivery pode ser uma grande causa para as avaliações ruins no dataset.

  <img width="467" height="135" alt="image" src="https://github.com/user-attachments/assets/8f67ed7a-fd9e-43f1-975d-24b2cdd8113a" />

- Foi calculado o percentual de pedidos em atraso por UF de residência do cliente, e constatou-se que os estados das regiões sudeste e sul lideram em quantidade de pedidos, e também contém alto percentual de pedidos entregues em atraso.

  <img width="375" height="134" alt="image" src="https://github.com/user-attachments/assets/c12bec2b-109f-4cea-9e72-7cd4a8e8a3b3" />

- Já os estados das demais regiões do Brasil (Norte, Nordeste e Centro-Oeste) possuem o percentual de pedidos mais baixo, porém alto percentual de pedidos com entrega em atraso
  
  <img width="383" height="394" alt="image" src="https://github.com/user-attachments/assets/d58d3692-a269-45e8-9ae9-d863640b3ab8" />








### 📬 Contato
Se quiser conversar sobre o projeto ou oportunidades:  

**Matheus Augusto**  
📧 silvamatheusaugusto36@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/matheus-augusto-silva-582230215)  

### 📜 Licença
Este projeto está sob a licença MIT. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---
