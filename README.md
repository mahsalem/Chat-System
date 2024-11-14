# README

### Deployment instructions:
  ```$ docker-compose up --build```
### Docker Images
  <table>
    <thead>
      <tr>
        <th>Container</th>
        <th>Port</th>
        <th>Description</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>db-1</td>
        <td>3306</td>
        <td>MySQL database</td>
      </tr>
      <tr>
        <td>elasticsearch-1</td>
        <td>9200</td>
        <td>Elasticsearch</td>
      </tr>
      <tr>
        <td>redis-1</td>
        <td>6379</td>
        <td>Redis</td>
      </tr>
      <tr>
        <td>zookeeper-1</td>
        <td>2181</td>
        <td>ZooKeeper for managing Kafka</td>
      </tr>
      <tr>
        <td>kafka-1</td>
        <td>9092</td>
        <td>Kafka</td>
      </tr>
      <tr>
        <td>rails-1</td>
        <td>3000</td>
        <td>Containerized rails application</td>
      </tr>
      <tr>
        <td>kowl-1</td>
        <td>7000</td>
        <td>Kowl for Kafka visualization</td>
      </tr>
      <tr>
        <td>karafka-1</td>
        <td>-</td>
        <td>Karafka for managing rails kafka consumers</td>
      </tr>
    </tbody>
  </table>

### API
- Applications
  <table>
    <thead>
      <tr>
        <th>Method</th>
        <th>Path</th>
        <th>Description</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>GET</td>
        <td>/applications/:token</td>
        <td></td>
      </tr>
      <tr>
        <td>POST</td>
        <td>/applications?name=:{name}</td>
        <td></td>
      </tr>
      <tr>
        <td>PATCH</td>
        <td>/applications/:token?name={new_name}</td>
        <td></td>
      </tr>
      <tr>
        <td>DELETE</td>
        <td>/applications/:token</td>
        <td></td>
      </tr>
    </tbody>
  </table>
- Chats
  <table>
    <thead>
      <tr>
        <th>Method</th>
        <th>Path</th>
        <th>Description</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>GET</td>
        <td>/applications/:application_token/chats</td>
        <td></td>
      </tr>
      <tr>
        <td>GET</td>
        <td>/applications/:application_token/chats/:number</td>
        <td></td>
      </tr>
      <tr>
        <td>GET</td>
        <td>/applications/:application_token/chats/:number/search?query={query}</td>
        <td></td>
      </tr>
      <tr>
        <td>POST</td>
        <td>/applications/:application_token/chats</td>
        <td></td>
      </tr>
      <tr>
        <td>DELETE</td>
        <td>/applications/:application_token/chats/:number</td>
        <td></td>
      </tr>
    </tbody>
  </table>
- Messages
  <table>
    <thead>
      <tr>
        <th>Method</th>
        <th>Path</th>
        <th>Description</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>GET</td>
        <td>/applications/:application_token/chats/:chat_number/messages</td>
        <td></td>
      </tr>
      <tr>
        <td>GET</td>
        <td>/applications/:application_token/chats/:chat_number/messages/:number</td>
        <td></td>
      </tr>
        <td>POST</td>
        <td>/applications/:application_token/chats/:chat_number/messages?body={message_body}</td>
        <td></td>
      </tr>
      <tr>
        <td>PATCH</td>
        <td>/applications/:application_token/chats/:chat_number/messages/:number?body={new_body}</td>
        <td></td>
      </tr>
      <tr>
        <td>DELETE</td>
        <td>/applications/:application_token/chats/:chat_number/messages/:number</td>
        <td></td>
      </tr>
    </tbody>
  </table>

### System Design
  ![Screenshot 2024-11-14 at 4 52 46 PM](https://github.com/user-attachments/assets/21f0854a-82bd-4514-82de-9404bbc72fd1)

### Database Schema
![Screenshot 2024-11-14 at 5 03 06 PM](https://github.com/user-attachments/assets/42888f2e-e9de-4ee7-80ba-73afd75ea347)

