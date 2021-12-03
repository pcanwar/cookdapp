import './App.css';
import { NavLink } from 'react-router-dom';

function App() {
  return (
    <div className="main__container">
      <div className="center__container">
        <NavLink to='/test'>
          <button>Test</button>
        </NavLink>
      </div>
    </div>
  );
}

export default App;
