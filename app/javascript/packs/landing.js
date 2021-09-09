import React, { useState, useEffect } from 'react'
import ReactDOM from 'react-dom'
import MaterialTable from 'material-table';

import TablePagination from '@material-ui/core/TablePagination';
import Input from '@material-ui/core/Input';
import Button from '@material-ui/core/Button';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Snackbar from '@material-ui/core/Snackbar';
import Alert from '@material-ui/lab/Alert';

const Landing = () => {
  const [links, setLanding] = useState([]);
  const [original, setOriginal] = useState('');
  const [requestResult, setRequestResult] = useState();
  const url = 'api/v1/links';

  const csrf = document.querySelector("meta[name='csrf-token']").getAttribute("content");

  function retrieveLanding() {
    fetch(url)
      .then((data) => {
        if (data.ok) {
          return data.json();
        }
        throw new Error("Network error.");
      })
      .then((data) => {
        setLanding(data);
      })
      .catch((err) => message.error("Error: " + err));
  }

  useEffect(() => {
    retrieveLanding();
  }, [original]);

  const handleClose = () => {
    setRequestResult();
  };

  function createLink() {
    fetch(url, {
      method: 'post',
      headers: {
        'Content-Type':'application/json',
        'X-CSRF-Token': csrf
      },
      body: JSON.stringify({
        'original': original
      })
    }).then(response=>response.json())
      .then(data=>{ setRequestResult(data.original[0]); })
    ;
  }

  return (
    <div>
      <div>
        <AppBar position="static">
          <Toolbar variant="dense">
            <Typography variant="h6" color="inherit">
              My Shortener
            </Typography>
          </Toolbar>
        </AppBar>
        <Input value={original} placeholder='Insert a valid URL to get a shortened version' inputProps={{ 'aria-label': 'Insert a valid URL to get a shortened version' }} fullWidth={true} onChange={(value) => { value.target.value && setOriginal(value.target.value) }}/>
        <Button variant="contained" color="primary" disableElevation label="Short" onClick={({ message }) => {
          createLink();
          setOriginal('');
        }}> Short </Button>
        <Snackbar open={requestResult !== undefined} autoHideDuration={6000} onClose={handleClose}>
          <Alert onClose={handleClose} severity={(requestResult || '').includes('not') ? 'error' : 'success'} >
            {requestResult === 'h' ? 'Ok' : requestResult}
          </Alert>
        </Snackbar>
      </div>
      <div style={{ maxWidth: "100%" }}>
        <MaterialTable
          options={{
            pageSize: 20,
            selection: false,
            paginationType: "normal",
            pageSizeOptions: [5, 10, 20],
            sorting: false,
            search: false,
            emptyRowsWhenPaging: false,
            showFirstLastPageButtons: true,
            draggable: false,
            rowStyle: (data, index) => {
              if (index % 2) {
                return { backgroundColor: "#f1f1f1" };
              }
            },
          }}

          columns={[
            { title: "URL", field: "original" },
            { title: "Shortened", field: "shortened", render: ({ shortened }) =>  <a href={shortened}>{shortened}</a> },
            { title: "Avg Access per Month", field: "frequency" },
            { title: "Last Access", field: "updated_at" },
            { title: "User who set it", field: "username" },
          ]}
          data={links}
          title="Landing"
          components={{
            Pagination: (props) => {
              return (
                <TablePagination
                  component="div"
                  backIconButtonProps={{ 'aria-label': '<' }}
                  nextIconButtonProps={{ 'aria-label': '>' }}
                  labelRowsPerPage='Per page: '
                  labelDisplayedRows={({ from, to, count }) => `${from}-${to} from ${count}`}
                  count={links.length}
                  page={props.page}
                  rowsPerPage={props.rowsPerPage}
                  rowsPerPageOptions={props.rowsPerPageOptions}
                  onPageChange={props.onPageChange}
                  onChangePage={props.onPageChange}
                  onChangeRowsPerPage={props.onRowsPerPageChange}
                  onRowsPerPageChange={props.onRowsPerPageChange}

                />
              )
            }
          }}
        />
      </div>
    </div>
  )}


Landing.propTypes = {
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Landing name="React" />,
    document.body.appendChild(document.createElement('div')),
  )
})
