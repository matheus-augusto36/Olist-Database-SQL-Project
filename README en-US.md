# 📊 Business Insights from Reviews

---

This project aims to **extract initial business insights from customer reviews using SQL**.  
Analyzing reviews allows us to better understand consumer perceptions, identify strengths, detect opportunities for improvement, and support strategic decisions.

### 🚀 Objectives
- Collect and organize customer reviews.
- Identify patterns based on reviews (scores from 1 to 5).  
- Generate metrics and visualizations that support business decisions.  

### 🛠️ Technologies/Concepts Used
- SQL  
- JOIN  
- Subqueries  
- WITH structure  
- Percentage calculation  

### 📈 Analysis
Note: Use of a sample (evaluation table) of 25,305 records from a database with a total of 96,461 registered orders (approximately 25%).
- Approximately 77% of the evaluated orders in the sample received a good score (4 and 5);
  
  <img width="223" height="74" alt="image" src="https://github.com/user-attachments/assets/a040fe4f-5b9d-400c-b202-e5d9cdc73fbe" />


- The categories with more than 20% poor ratings together account for 80% of all orders with unsatisfactory ratings in the sample.

  <img width="205" height="56" alt="image" src="https://github.com/user-attachments/assets/cfcb112e-4920-4356-a57d-bf58ea91095a" />
  
- The product categories with the most negative reviews are: diapers_hygiene, fashion_men's_clothing, landline_telephony, audio, and office_furniture.
To assess the representativeness of these categories in relation to the total sample, the percentage of orders for each category was calculated, and it was found that they have no significant impact on the business (representing about 2.2% of the total orders in the sample).

  <img width="571" height="116" alt="image" src="https://github.com/user-attachments/assets/0ce74139-1398-4ee4-8011-686c0280e0f3" />

- On the other hand, the most representative product categories were calculated based on the percentage of orders, all with more than 20% bad reviews.
  
  <img width="598" height="137" alt="image" src="https://github.com/user-attachments/assets/f5dfa890-a06a-44a2-8a7e-c8dd75edb62f" />

- After calculating the percentage of orders with delayed delivery, it was found that in each of these product categories, there is a delay in delivery in about 67% to 76% of the orders in the sample. This shows that delivery problems can be a major cause of poor ratings in the dataset.

  <img width="467" height="135" alt="image" src="https://github.com/user-attachments/assets/8f67ed7a-fd9e-43f1-975d-24b2cdd8113a" />

- The percentage of late orders was calculated by state of residence of the customer, and it was found that the states in the southeast and south regions lead in terms of number of orders, and also have a high percentage of late deliveries.

  <img width="375" height="134" alt="image" src="https://github.com/user-attachments/assets/c12bec2b-109f-4cea-9e72-7cd4a8e8a3b3" />

- The states in the other regions of Brazil (North, Northeast, and Midwest) have the lowest percentage of orders, but a high percentage of orders delivered late.
  
  <img width="383" height="394" alt="image" src="https://github.com/user-attachments/assets/d58d3692-a269-45e8-9ae9-d863640b3ab8" />

### 📌 Conclusion
 - Overall satisfaction is favorable, with 77% of orders receiving good reviews, but delivery delays can be considered the main cause of poor reviews.
 - Analysis of delays by state shows that the problem affects all regions of the country, indicating an opportunity for improvement in the logistics sector of the business, especially in the Southeast and South regions where there is a higher volume of orders.

### 📬 Contact
If you would like to discuss the project or opportunities:

**Matheus Augusto**  
📧 silvamatheusaugusto36@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/matheus-augusto-silva-582230215)  

### 📜 License
This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for more details.

---
